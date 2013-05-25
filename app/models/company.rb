class Company < ActiveRecord::Base
  belongs_to :activity
  belongs_to :friend
  
end
