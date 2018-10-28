class AddSettleDaysToSalaries < ActiveRecord::Migration
  def change
    add_column :salaries, :settle_times, :string
    add_column :salaries, :settle_times_score, :integer
  end
end
