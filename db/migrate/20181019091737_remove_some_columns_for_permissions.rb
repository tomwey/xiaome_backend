class RemoveSomeColumnsForPermissions < ActiveRecord::Migration
  def change
    remove_column :permission_resources, :actions
    remove_column :permission_resources, :action_names
  end
end
