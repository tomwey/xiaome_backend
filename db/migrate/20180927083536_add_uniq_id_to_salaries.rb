class AddUniqIdToSalaries < ActiveRecord::Migration
  def change
    add_column :salaries, :uniq_id, :string
    add_index :salaries, :uniq_id, unique: true
  end
end
