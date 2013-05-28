class Activity < ActiveRecord::Base
  has_many :companies
  has_many :friends, through: :companies
  # has_one :location TODO
  
  # 
  # Commands that can be executed on activity models by rules engine
  # 
  COMMANDS = ['set_name',
              'set_category',
              'set_objective',
              'set_mood',
              'add_friend',
              'add_time']
  
  def set_name(str)
    self.name = normalize_str(str)
  end
  
  def set_category(str)
    self.category = normalize_str(str)
  end
  
  def set_objective(hsh)
    self.objective = normalize_str(hsh['objective'])
  end
  
  def set_mood(str)
    self.mood = "#{normalize_str(str)}!" # Good mood! Bad mood!
  end
  
  def add_friend(name, fb_id)
    friend = Friend.where(fb_id: fb_id).first_or_initialize
    friend.name = name
    self.friends << friend unless self.friends.map(&:fb_id).include?(fb_id)
  end
  
  # eg. add_time('2', 'minute')
  def add_time(num, unit)
    self.time ||= 0
    self.time += num.to_i.send(unit)
  end
  
  private
  
    def normalize_str(str)
      str.is_a?(String) ? str.strip.titlecase : nil
    end
end
