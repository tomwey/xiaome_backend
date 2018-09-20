class CreateAuthProfiles < ActiveRecord::Migration
  def change
    create_table :auth_profiles do |t|
      t.string :openid, null: false
      t.string :provider
      t.string :nickname
      t.string :sex
      t.string :headimgurl
      t.string :unionid
      t.string :access_token
      t.string :refresh_token
      t.integer :user_id
      t.integer :merch_id
      t.string :city
      t.string :language
      t.string :province
      t.string :country

      t.timestamps null: false
    end
    add_index :auth_profiles, :openid
    add_index :auth_profiles, :user_id
    add_index :auth_profiles, :merch_id
  end
end
