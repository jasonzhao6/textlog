class Rule < ActiveRecord::Base
  scope :sorted, -> { order('updated_at DESC') }
  serialize :arg
  
  # bump updated_at, which is used to resolve competing rules
  def bump!
    save
  end
end
