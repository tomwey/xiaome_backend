class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.integer :uniq_id
      t.string :title, null: false
      t.string :body
      t.string :money, null: false
      t.boolean :opened, default: true
      t.integer :sort, default: 0
      
      t.timestamps null: false
    end
    add_index :projects, :uniq_id, unique: true
    add_index :projects, :sort
  end
end
