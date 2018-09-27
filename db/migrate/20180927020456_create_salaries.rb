class CreateSalaries < ActiveRecord::Migration
  def change
    create_table :salaries do |t|
      t.integer :user_id, null: false
      t.integer :project_id, null: false
      t.integer :money, null: false
      t.datetime :payed_at

      t.timestamps null: false
    end
    add_index :salaries, :user_id
    add_index :salaries, :project_id
  end
end
