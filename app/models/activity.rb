class Activity < ActiveRecord::Base
  has_many :companies
  has_many :friends, through: :companies
  
  # 
  # Commands that can be executed on activity models by rules engine
  # 
  COMMANDS = ['set_name',
              'set_category',
              'set_accomplishment',
              'set_mood',
              'add_friend',
              'add_duration']
  
  def set_name(str)
    self.name = str.titlecase
  end
  
  def set_category(str)
    self.category = str.titlecase
  end
  
  def set_accomplishment(str)
    self.accomplishment = str.titlecase
  end
  
  def set_mood(str)
    self.mood = "#{str.titlecase}!" # Good mood! Bad mood!
  end
  
  def add_friend(name, fb_id)
    friend = Friend.where(fb_id: fb_id).first_or_initialize
    friend.name = name
    self.friends << friend unless self.friends.map(&:fb_id).include?(fb_id)
  end
  
  # eg. add_duration('2', 'minute')
  def add_duration(num, unit)
    self.duration ||= 0
    self.duration += num.to_i.send(unit)
  end
end
