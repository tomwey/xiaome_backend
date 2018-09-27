class AddPayNameAndPayAccountToSalaries < ActiveRecord::Migration
  def change
    add_column :salaries, :pay_name, :string
    add_column :salaries, :pay_account, :string
  end
end
