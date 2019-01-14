class CreateClockEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :clock_events do |t|

      t.timestamps
    end
  end
end
