class CreateAdminUsersPermissions < ActiveRecord::Migration
  def change
    create_table :admin_users_permissions, id: false do |t|
      t.belongs_to :admin_user
      t.belongs_to :permission
    end
  end
end
