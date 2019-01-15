FactoryBot.define do
  factory :clock_event do
    name "Josh"
    time_in DateTime.now - 10.minutes
    time_out DateTime.now
  end
end
