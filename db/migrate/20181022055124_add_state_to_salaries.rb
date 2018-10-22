class AddStateToSalaries < ActiveRecord::Migration
  def change
    add_column :salaries, :state, :string, default: 'pending'
  end
end
