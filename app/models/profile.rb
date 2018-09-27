class Profile < ActiveRecord::Base
  belongs_to :user
  validates :name, :sex, :idcard, presence: true
end
