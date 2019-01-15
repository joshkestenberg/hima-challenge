class ClockEventsController < ApplicationController
  # I felt that the index of all clock events should require authentication
  http_basic_authenticate_with name: "admin", password: Figaro.env.index_password, only: :index

  def home
  end

  def punch_clock
    @name = search_params[:name]
    @clock_events = ClockEvent.user_last_ten(@name)
    # using a variable to determine whether or not to use jQuery animation
    @animate = true

    # If a user has prior clock events, and the last clock event doesn't have a time out,
    # we know to punch out. In all other instances, we're punching in.
    @punch_out = ClockEvent.punch_out?(@name)

    # If we are punching out, we need to update the user's last clock event, whereas if we're
    # punching in, we'll need to create a new clock event
    @clock_event = @punch_out ? @clock_events.last : ClockEvent.new

    respond_to do |f|
      f.js { render 'punch-clock' }
    end
  end

  def index
    @parent_action = :index

    @clock_events = ClockEvent.sort(params[:sort_by])
  end

  def create
    @clock_event = ClockEvent.new(event_params)
    @clock_event.time_in = DateTime.now

    if @clock_event.save
      reset_clock_event_vars(@clock_event)
      render_updated_clock_events
    end
  end

  def update
    @clock_event = ClockEvent.find(params[:id])
    @clock_event.time_out = DateTime.now

    if @clock_event.save
      reset_clock_event_vars(@clock_event)
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

    def reset_clock_event_vars(clock_event)
      @name = clock_event.name
      @clock_events = ClockEvent.user_last_ten(@name)
      @punch_out = ClockEvent.punch_out?(@name)

      # we don't want jquery animation when re-rendering punch clock
      @animate = false

      # If we are punching out, we need to update the user's last clock event, whereas if we're
      # punching in, we'll need to create a new clock event
      @clock_event = @punch_out ? @clock_events.last : ClockEvent.new

    end

    def render_updated_clock_events
      respond_to do |f|
        f.js { render 'punch-clock' }
      end
    end

end
