class Rule < ActiveRecord::Base
  serialize :arg
  validates :command, presence: true
  
  def self.get_matchers(rules)
    rules.select { |rule| rule.parent_id.nil? }
  end
  
  def self.get_setters(rules, matcher)
    rules.select { |rule| rule.parent_id == matcher.id }
  end
  
  # bump updated_at, which is used to resolve competing rules
  def bump!
    save
  end
end
