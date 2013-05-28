class Message < ActiveRecord::Base
  
  # 
  # Commands that can be executed on message models by rules engine
  # JZ: decided not to implement .split to avoid dealing with arrays
  # 
  COMMANDS = ['match']
  
  def match(pattern)
    self.body.match(/#{pattern}/i)
  end
end
