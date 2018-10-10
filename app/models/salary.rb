class Salary < ActiveRecord::Base
  validates :project_id, :money, :pay_name, :pay_account, presence: true
  validates :money, numericality: { greater_than_or_equal_to: 0 }
  
  belongs_to :user
  belongs_to :project
  
  before_create :generate_oid
  
  scope :unpayed, -> { where(payed_at: nil) }
  scope :payed, -> { where.not(payed_at: nil) }
  
  def generate_oid
    begin
      self.uniq_id = Time.now.to_s(:number)[2,6] + (Time.now.to_i - Date.today.to_time.to_i).to_s + Time.now.nsec.to_s[0,6]
    end while self.class.exists?(:uniq_id => uniq_id)
  end
  
  def self.all_projects_for(user)
    proj_ids = Salary.where(user_id: user.id).pluck(:project_id)
    Project.where(opened: true).where.not(id: proj_ids)
  end
  
  def confirm_pay!
    code,msg = Alipay::Pay.pay(self.uniq_id, self.pay_account, self.pay_name, (money * 100))
    if code == 0
      self.payed_at = Time.zone.now
      self.save!
      
      # 通知管理员
      # notify_backend_manager('')
      
      return ''
    else
      
      # 通知管理员
      # notify_backend_manager(msg)
      
      return msg
    end
  end # end method
  
end
