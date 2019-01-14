class AddColumnsToClockEvent < ActiveRecord::Migration[5.1]
  def change
    add_column :clock_events, :time_in, :datetime
    add_column :clock_events, :time_out, :datetime
    add_column :clock_events, :name, :string
  end
end
