class Activity < ActiveRecord::Base
  has_many :companies
  has_many :friends, through: :companies
  
  # JZ: could have overwritten 'as_json', but saving it for API generation
  def preview
    to_json(except: [:id, :message_id, :company_id],
            include: [friends: { except: [:id] }])
  end
  
  # 
  # Commands that can be sent to activity models
  # 
  COMMANDS = ['set_name',
              'set_category',
              'set_objective',
              'set_experience',
              'add_friend',
              'add_time'] # Used to validate rules
  
  def set_name(str)
    self.name = titlecase_str(str)
  end
  
  def set_category(str)
    self.category = titlecase_str(str)
  end
  
  # eg set_objective({ 'objective' => 'butterlap' })
  def set_objective(hsh)
    hsh = indifferent_hsh(hsh)
    self.objective = titlecase_str(hsh[:objective])
  end
  
  # eg set_experience({ 'experience' => 'engaged' })
  def set_experience(hsh)
    hsh = indifferent_hsh(hsh)
    self.experience = hsh[:experience]
    
    # TODO show trailing '!' in view
  end
  
  # eg add_friend({ name: 'Somebody', fb_id: 'somebody' })
  def add_friend(hsh)
    hsh = indifferent_hsh(hsh)
    friend = Friend.where(fb_id: hsh[:fb_id]).first_or_initialize
    friend.name = hsh[:name]
    self.friends << friend unless self.friends.map(&:fb_id).include?(hsh[:fb_id])
  end
  
  # eg add_time({ 'num' => '2', 'unit' => 'min' })
  def add_time(hsh)
    hsh = indifferent_hsh(hsh)
    num = hsh[:num].to_i
    unit = normalize_time_unit(hsh[:unit])
    self.time ||= 0
    self.time += num.send(unit)
  end
  
  private
    
    def titlecase_str(str)
      str.is_a?(String) ? str.strip.titlecase : nil
    end
  
    def indifferent_hsh(hsh)
      hsh.is_a?(Hash) ? hsh.with_indifferent_access : {}
    end
    
    def normalize_time_unit(unit)
      case unit
      when 'hr' then :hour
      when 'min' then :minute
      end
    end
end
