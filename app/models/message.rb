class Message < ActiveRecord::Base
  scope :unparsed, -> { where(parsed: nil).order('created_at DESC') }
  validates :message, presence: true
  
  # 
  # Commands that can be sent to message models
  # 
  COMMANDS = ['match']
  
  def match(pattern)
    self.message.match(/#{pattern}/i) if pattern
  end
end
