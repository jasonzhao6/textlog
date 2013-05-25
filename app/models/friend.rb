class Friend < ActiveRecord::Base
  has_many :activities, through: :companies
  has_many :companies

end
