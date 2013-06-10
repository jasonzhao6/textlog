class Message < ActiveRecord::Base
  has_one :activity
  # When activities table is empty, 'Activity.pluck(:message_id)' returns '[]'.
  # When that happens, the where clause because "where('id not in (?)', [])",
  # which returns nothing. By defaulting '[]' to '[0]', we avoid this problem
  # since db ids are never 0.
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
