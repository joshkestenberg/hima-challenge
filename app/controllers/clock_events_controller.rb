class ClockEventsController < ApplicationController
  def home
  end

  def punch_clock
    @name = search_params[:name]
    @clock_events = ClockEvent.where(name: @name)
    @last_event = @clock_events.last

    # If a user has prior clock events, and the last clock event doesn't have a time out,
    # we know to punch out. In all other instances, we're punching in.
    @punch_out = @clock_events.present? && @last_event.time_out.nil?

    # If we are punching out, we need to update the user's last clock event, whereas if we're
    # punching in, we'll need to create a new clock event
    @clock_event = @punch_out ? @last_event : ClockEvent.new

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
      # set punch_out to true as we just punched in, and reset clock_event variables
      @punch_out = true
      @clock_events = ClockEvent.where(name: @clock_event.name)
      # next clock event will be a clock out, so we need to reset clock event var to last saved object
      @clock_event = @clock_events.last
      render_updated_clock_events
    end
  end

  def update
    @clock_event = ClockEvent.find(params[:id])
    @clock_event.time_out = DateTime.now

    if @clock_event.save
      # reset punch_out to false as we just punched out, and reset clock_event variables
      @punch_out = false
      @clock_events = ClockEvent.where(name: @clock_event.name)
      # next clock event will be a clock in, so we need to reset clock event var to a new object
      @name = @clock_event.name
      @clock_event = ClockEvent.new
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

    def render_updated_clock_events
      respond_to do |f|
        f.js { render 'punch-clock' }
      end
    end

end
