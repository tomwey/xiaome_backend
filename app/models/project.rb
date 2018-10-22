class Project < ActiveRecord::Base
  has_many :salaries, dependent: :destroy
  
  before_create :generate_unique_id
  def generate_unique_id
    begin
      n = rand(10)
      if n == 0
        n = 8
      end
      self.uniq_id = (n.to_s + SecureRandom.random_number.to_s[2..6]).to_i
    end while self.class.exists?(:uniq_id => uniq_id)
  end
  
  def confirm_pay!
    SendSalaryJob.perform_later(self.id)
  end
  
  def total_salary_money
    @mm ||= salaries.sum(:money)
  end
  
  def sent_salary_money
    @m2 ||= salaries.where.not(payed_at: nil).sum(:money)
  end
  
  def senting_salary_money
    @money ||= salaries.where(payed_at: nil, state: 'approved').sum(:money)
  end
  
end
