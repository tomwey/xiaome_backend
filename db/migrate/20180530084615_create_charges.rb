class CreateCharges < ActiveRecord::Migration
  def change
    create_table :charges do |t|
      t.string :uniq_id
      t.integer :money, null: false, default: ''
      t.integer :pay_type, default: 1 # 支付类型，1 表示微信支付 2 表示支付宝支付
      t.integer :user_id, null: false
      t.string :ip
      t.datetime :payed_at
      
      t.timestamps null: false
    end
    add_index :charges, :uniq_id, unique: true
    add_index :charges, :user_id
  end
end
