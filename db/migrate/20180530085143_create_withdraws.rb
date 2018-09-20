class CreateWithdraws < ActiveRecord::Migration
  def change
    create_table :withdraws do |t|
      t.string :uniq_id
      t.integer :money, null: false
      t.integer :fee, default: 0
      t.string :account_no, null: false
      t.string :account_name
      t.integer :user_id
      t.datetime :payed_at
      t.string :note

      t.timestamps null: false
    end
    add_index :withdraws, :uniq_id, unique: true
    add_index :withdraws, :user_id
    
  end
end
