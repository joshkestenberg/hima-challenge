class ClockEvent < ApplicationRecord
  scope :user_last_ten, ->(name) {where(name: name).order(time_in: :DESC).limit(10).reverse}

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
