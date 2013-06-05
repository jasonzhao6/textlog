class Activity < ActiveRecord::Base
  has_many :companies
  has_many :friends, through: :companies
  
  # 
  # Rspec helpers
  # 
  def as_json(options = {})
    super(except: [:id, :message_id, :company_id],
          include: [friends: { except: [:id] }])
  end
  
  # 
  # Commands that can be sent to activity models
  # 
  
  # Used to validate rules
  COMMANDS = ['set_name',
              'set_category',
              'set_objective',
              'set_experience',
              'add_friend',
              'add_time',
              'add_reps']
  
  # eg set_name('biking')
  def set_name(arg)
    self.name = titlecase_str(arg)
  end
  
  # eg set_category('fitness')
  def set_category(arg)
    self.category = titlecase_str(arg)
  end
  
  # eg set_objective('marin headlands')
  # eg set_objective({ 'objective' => 'marin headlands' })
  def set_objective(arg)
    arg = indifferent_hsh(arg)[:objective] if arg.is_a?(Hash)
    self.objective = titlecase_str(arg)
  end
  
  # eg set_experience('felt engaged')
  # eg set_experience({ 'experience' => 'felt engaged' })
  def set_experience(arg)
    arg = indifferent_hsh(arg)[:experience] if arg.is_a?(Hash)
    self.experience = capitalize_str(arg)
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
  
  # eg add_reps('10')
  # eg add_reps({ 'reps' => '10' })
  def add_reps(arg)
    arg = indifferent_hsh(arg)[:reps] if arg.is_a?(Hash)
    self.reps = convert_to_i(arg)
  end
  
  private
    
    # 
    # Commands helpers
    # 
    def convert_to_i(str)
      str.present? ? str.to_i : nil
    end
    
    def capitalize_str(str)
      str.is_a?(String) ? str.strip.capitalize : nil
    end
  
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
