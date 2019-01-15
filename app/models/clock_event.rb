class ClockEvent < ApplicationRecord
  validates :name, :time_in, presence: true

  scope :user_last_ten, ->(name) {user_events(name).order(time_in: :DESC).limit(10).reverse}

  def self.punch_out?(name)
    user_events(name).present? && user_events(name).last.time_out.nil?
  end

  def self.user_events(name)
    where(name: name)
  end

  def self.sort(sort_by)
    case sort_by
    when "name"
      ClockEvent.all.order(name: :ASC)
    when "time_out"
      ClockEvent.all.order(time_out: :ASC)
    else
      # time_in just falls to the default case; no need for its own case
      ClockEvent.all.order(time_in: :ASC)
    end
  end
end
