class Rule < ActiveRecord::Base
  serialize :arg
  
  # bump updated_at, which is used to resolve competing setters
  def bump
    save
  end
end
