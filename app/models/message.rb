class Message < ActiveRecord::Base
  
  # 
  # Commands that can be called on a message bodies by rules engine
  # 
  COMMANDS = ['match']
  
end
