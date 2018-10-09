class ChangeMoneyTypeForSalaries < ActiveRecord::Migration
  def change
    change_column :salaries, :money, :decimal, precision: 10, scale: 2 
    # 10,000,000.00
  end
end
