class AddVisibleToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :visible, :boolean, default: true
  end
end
