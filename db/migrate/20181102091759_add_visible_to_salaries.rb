class AddVisibleToSalaries < ActiveRecord::Migration
  def change
    add_column :salaries, :visible, :boolean, default: true
  end
end
