class Message < ActiveRecord::Base
  scope :unparsed, -> { where(parsed: nil) }
  validates :message, :presence => true
  
  # 
  # Commands that can be executed on message models by rules engine
  # JZ: decided not to implement .split to avoid dealing with arrays
  # 
  COMMANDS = ['match']
  
  def match(pattern)
    self.message.match(/#{pattern}/i)
  end
end
