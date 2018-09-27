class AddCurrentPayNameAndCurrentPayAccountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :current_pay_name, :string
    add_column :users, :current_pay_account, :string
  end
end
