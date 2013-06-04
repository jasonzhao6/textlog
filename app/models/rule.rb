class Rule < ActiveRecord::Base
  belongs_to :matcher, class_name: 'Rule'
  has_many :setters, class_name: 'Rule', foreign_key: 'matcher_id'
  serialize :arg
  validates :command, presence: true
  validates :command, inclusion: { in: (Message::COMMANDS + Activity::COMMANDS) }
  
  # 
  # Rspec helpers
  # 
  def as_json(options = {})
    super(except: [:created_at, :updated_at, :id, :matcher_id],
          include: [matcher: { except: [:created_at, :updated_at, :id] }])
  end
  
  # 
  # Getters used by rules_engine and views
  # 
  def self.get_matchers(rules)
    rules.select { |rule| rule.matcher_id.nil? }
  end
  
  def self.get_setters(rules, matcher)
    rules.select { |rule| rule.matcher_id == matcher.id }
  end
  
  # bump updated_at, which is used to resolve competing rules
  def bump!
    save
  end
end
