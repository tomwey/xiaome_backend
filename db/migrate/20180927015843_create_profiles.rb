class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.integer :user_id, null: false
      t.string :name, null: false
      t.string :sex,  null: false
      t.string :birth
      t.string :phone
      t.string :idcard, null: false
      t.boolean :is_student, default: true
      t.string :college
      t.string :specialty

      t.timestamps null: false
    end
    add_index :profiles, :user_id, unique: true
  end
end
