class Friend < ActiveRecord::Base
  has_many :activities, through: :companies
  has_many :companies
  validates :name, presence: true
  validates :fb_id, presence: true
end
