class AddAmountToTimesheets < ActiveRecord::Migration[5.2]
  def change
    add_column :timesheets, :amount, :float
  end
end
