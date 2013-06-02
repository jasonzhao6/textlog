class Message < ActiveRecord::Base
  scope :unparsed, -> { where(parsed: nil) }
  validates :message, presence: true
  
  # 
  # Commands that can be sent to message models
  # 
  COMMANDS = ['match'] # Used to validate rules
  
  def match(pattern)
    self.message.match(/#{pattern}/i)
  end
end
