class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :pretty_time

  def pretty_time(datetime)
    datetime.in_time_zone(cookies[:timezone]).strftime('%d-%m-%y %-I:%M%P')
  end
end
