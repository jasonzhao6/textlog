# A rule can be a matcher or a setter.
# A matcher matches a regex pattern on a message.
# A setter calls a custome setter on an activity.
# A matcher can have many setters, and a setter can belong to a matcher.
# The tell between a matcher and a setter is whether it has matcher_id.
class Rule < ActiveRecord::Base
  before_save :set_cnt_was_last_updated
  belongs_to :matcher, class_name: 'Rule'
  has_many :setters, class_name: 'Rule', foreign_key: 'matcher_id'
  scope :matchers, -> { where(matcher_id: nil)
                       .includes(:setters)
                       .order('rules.updated_at DESC') }
  scope :matchers_for, lambda { |command| matchers
                                         .where('setters_rules.command = ?', command)
                                         .references(:setters) }
  serialize :arg
  validates :arg, presence: true, if: :is_matcher?
  validates :command, inclusion: { in: Message::COMMANDS }, if: :is_matcher?
  validates :command, inclusion: { in: Activity::COMMANDS }, if: :is_setter?
  
  # 
  # Rspec helpers
  # 
  def as_json(options = {})
    super(except: [:created_at, :updated_at, :id, :matcher_id],
          include: [matcher: { except: [:created_at, :updated_at, :id] }])
  end
  
  private
  
    # 
    # Before filters
    # 
    def set_cnt_was_last_updated
      self.cnt_was_last_updated = self.cnt_changed?
      return # Rails is not happy when a before filter returns false
    end
    
    def is_matcher?
      self.matcher_id.nil?
    end
    
    def is_setter?
      self.matcher_id.present?
    end
end
