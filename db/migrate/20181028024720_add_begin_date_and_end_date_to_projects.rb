class AddBeginDateAndEndDateToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :begin_date, :date
    add_column :projects, :end_date, :date
  end
end
