class Profile < ActiveRecord::Base
  belongs_to :user
  validates :name, :sex, :idcard, presence: true
  validates :idcard, format: { with: /\A\d{6}(18|19|20)?\d{2}(0[1-9]|1[012])(0[1-9]|[12]\d|3[01])\d{3}(\d|[xX])\z/, message: '不正确的身份证号码' }
end
