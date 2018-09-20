class CreateTradeLogs < ActiveRecord::Migration
  def change
    create_table :trade_logs do |t|
      t.string :uniq_id
      t.integer :user_id, null: false
      t.integer :money, null: false
      t.string :title
      t.string :action
      t.references :tradeable, polymorphic: true, index: true

      t.timestamps null: false
    end
    add_index :trade_logs, :uniq_id, unique: true
    add_index :trade_logs, :user_id
  end
end
