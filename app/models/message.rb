class Message < ActiveRecord::Base
  has_one :activity
  # JZ: `where('id not in (?)', [])` yields no match.
  #     Defaulting '[]' to '[0]' prevents that since db id is never 0.
  scope :unparsed, -> { where('id not in (?)', Activity.pluck(:message_id) + [0])
                       .order('created_at DESC') }
  validates :message, presence: true
  
  # 
  # Commands that can be sent to message models
  # 
  COMMANDS = ['match']
  
  def match(pattern)
    self.message.match(/#{pattern}/i) if pattern
  end
end
