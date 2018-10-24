require 'roo'

class ImportSalaryJob < ActiveJob::Base
  queue_as :scheduled_jobs

  def perform(row)
    user_ids = Profile.where(phone: row['phone'], name: row['name']).pluck(:user_id)
    @salaries = Salary.where(user_id: user_ids, payed_at: nil, money: row['money'].to_f).all
    if @salaries.any?
      @salaries.map { |salary| salary.update(state: 'approved') }
    end
  end
  
end
