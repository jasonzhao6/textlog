# A rule can be a matcher or a setter.
# A matcher matches a regex pattern on a message.
# A setter calls a custome setter on an activity.
# A matcher can have many setters, and a setter can belong to a matcher.
# The difference between a matcher and a setter is whether it has matcher_id.
class Rule < ActiveRecord::Base
  belongs_to :matcher, class_name: 'Rule'
  has_many :setters, class_name: 'Rule', foreign_key: 'matcher_id'
  scope :matchers, -> { where(matcher_id: nil)
                       .includes(:setters)
                       .order('rules.updated_at DESC') }
  scope :setters_withought_matchers, -> { # These should never exist
    where('matcher_id not in (?)', Rule.matchers.pluck(:id)) }
  serialize :arg
  validates :command, inclusion: { in: (Message::COMMANDS + Activity::COMMANDS) }
  
  # 
  # Rspec helpers
  # 
  def as_json(options = {})
    super(except: [:created_at, :updated_at, :id, :matcher_id],
          include: [matcher: { except: [:created_at, :updated_at, :id] }])
  end
  
  # bump updated_at, which is used to resolve competing rules
  def bump!
    save
  end
end
