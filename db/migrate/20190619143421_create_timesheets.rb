class CreateTimesheets < ActiveRecord::Migration[5.2]
  def change
    create_table :timesheets do |t|
      t.datetime :date
      t.time :start_time
      t.time :finish_time

      t.timestamps
    end
  end
end
