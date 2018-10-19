class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.integer :resource_id
      t.string :action
      t.string :action_name
      t.boolean :need_scope, default: false
      t.text :memo

      t.timestamps null: false
    end
    add_index :permissions, :resource_id
  end
end
