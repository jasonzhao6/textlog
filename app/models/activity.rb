class Activity < ActiveRecord::Base
  has_many :companies
  has_many :friends, through: :companies
  # has_one :location TODO
  
  # 
  # Preview method that serializes activity model and its associations to json
  # Used for regression testing when adding new rules, tests that already parsed
  # messages are still parsed the same way
  # JZ: decided to not use as_json method, save it for future API use
  # 
  def preview
    to_json(except: [:id, :message_id, :company_id],
            include: [friends: { except: [:id] }])
  end
  
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
  
  # eg. set_objective({ 'objective' => 'butterlap' })
  def set_objective(hsh)
    hsh = normalize_hsh(hsh)
    self.objective = normalize_str(hsh[:objective])
  end
  
  # eg. set_mood({ 'mood' => 'engaged' })
  def set_mood(hsh)
    hsh = normalize_hsh(hsh)
    self.mood = "#{normalize_str(hsh[:mood])}!"
  end
  
  # eg. add_friend({ name: 'Somebody', fb_id: 'somebody' })
  def add_friend(hsh)
    hsh = normalize_hsh(hsh)
    friend = Friend.where(fb_id: hsh[:fb_id]).first_or_initialize
    friend.name = hsh[:name]
    self.friends << friend unless self.friends.map(&:fb_id).include?(hsh[:fb_id])
  end
  
  # eg. add_time({ 'num' => '2', 'unit' => 'min' })
  def add_time(hsh)
    hsh = normalize_hsh(hsh)
    num = hsh[:num].to_i
    unit = normalize_time_unit(hsh[:unit])
    self.time ||= 0
    self.time += num.send(unit)
  end
  
  private
    
    def normalize_str(str)
      str.is_a?(String) ? str.strip.titlecase : nil
    end
  
    def normalize_hsh(hsh)
      hsh.is_a?(Hash) ? hsh.with_indifferent_access : {}
    end
    
    def normalize_time_unit(unit)
      case unit
      when 'hr' then :hour
      when 'min' then :minute
      end
    end
end
