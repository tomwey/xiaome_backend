class Salary < ActiveRecord::Base
  validates :project_id, :money, presence: true
  validates :money, numericality: { greater_than: 0 }
  
  def self.all_projects_for(user)
    proj_ids = Salary.where(user_id: user.id).pluck(:project_id)
    Project.where(opened: true).where.not(id: proj_ids)
  end
end
