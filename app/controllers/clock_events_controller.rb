class ClockEventsController < ApplicationController
  # I felt that the index of all clock events should require authentication
  http_basic_authenticate_with name: "admin", password: Figaro.env.index_password, only: :index

  def home
  end

  def punch_clock
    @name = search_params[:name]
    @clock_events = ClockEvent.where(name: @name)

    # If a user has prior clock events, and the last clock event doesn't have a time out,
    # we know to punch out. In all other instances, we're punching in.
    @punch_out = @clock_events.present? && @clock_events.last.time_out.nil?

    # If we are punching out, we need to update the user's last clock event, whereas if we're
    # punching in, we'll need to create a new clock event
    @clock_event = @punch_out ? @clock_events.last : ClockEvent.new

    respond_to do |f|
      f.js { render 'punch-clock' }
    end
  end

  def index
    @clock_events = ClockEvent.all
  end

  def create
    @clock_event = ClockEvent.new(event_params)
    @clock_event.time_in = DateTime.now

    if @clock_event.save
      reset_clock_event_vars(:create, @clock_event)
      render_updated_clock_events
    end
  end

  def update
    @clock_event = ClockEvent.find(params[:id])
    @clock_event.time_out = DateTime.now

    if @clock_event.save
      reset_clock_event_vars(:update, @clock_event)
      render_updated_clock_events
    end
  end

  private

    def search_params
      params.permit(:name)
    end

    def event_params
      params.require(:clock_event).permit(:name)
    end

    def reset_clock_event_vars(parent_method, clock_event)
      @name = clock_event.name
      @clock_events = ClockEvent.where(name: @name)

      case parent_method
      when :create
        # set punch_out to true as we just punched in, and reset clock_event variables
        @punch_out = true
        # next clock event will be a clock out, so we need to reset clock event var to user's last saved object
        @clock_event = @clock_events.last
      when :update
        # reset punch_out to false as we just punched out, and reset clock_event variables
        @punch_out = false
        # next clock event will be a clock in, so we need to reset clock event var to a new object
        @clock_event = ClockEvent.new
      end

    end

    def render_updated_clock_events
      respond_to do |f|
        f.js { render 'punch-clock' }
      end
    end

end
