class CreatePermissionResources < ActiveRecord::Migration
  def change
    create_table :permission_resources do |t|
      t.string :func_name,    null: false
      t.string :func_class,   null: false
      t.string :actions,      null: false
      t.string :action_names, null: false
      t.integer :sort, default: 0
      t.boolean :opened, default: true

      t.timestamps null: false
    end
  end
end
