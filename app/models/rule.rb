class Rule < ActiveRecord::Base
  serialize :arg
  validates :command, presence: true
  
  # bump updated_at, which is used to resolve competing rules
  def bump!
    save
  end
end
