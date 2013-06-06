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
  COMMANDS = ['set_primary_type',
              'set_secondary_type',
              'add_friend',
              'add_duration',
              'set_distance',
              'set_reps',
              'set_note']
  
  # eg set_primary_type('biking')
  def set_primary_type(str)
    self.primary_type = titlecase_str(str)
  end
  
  # eg set_secondary_type('marin headlands')
  def set_secondary_type(str)
    self.secondary_type = titlecase_str(str)
  end
  
  # eg add_friend({ name: 'Somebody', fb_id: 'somebody' })
  def add_friend(hsh)
    hsh = indifferent_hsh(hsh)
    friend = Friend.where(fb_id: hsh[:fb_id]).first_or_initialize
    friend.name = hsh[:name] # in case friend's name has been updated
    self.friends << friend unless self.friends.map(&:fb_id).include?(hsh[:fb_id])
  end
  
  # eg add_duration({ 'num' => '1', 'unit' => 'hr' })
  # eg add_duration({ 'num' => '44', 'unit' => 'min' })
  def add_duration(hsh)
    hsh = indifferent_hsh(hsh)
    self.duration ||= 0
    self.duration += normalize_duration(hsh[:num], hsh[:unit])
  end
  
  # eg set_distance({ 'num' => '5', 'unit' => 'k' })
  # eg set_distance({ 'num' => '17.4', 'unit' => 'mi' })
  def set_distance(hsh)
    hsh = indifferent_hsh(hsh)
    self.distance = normalize_distance(hsh[:num], hsh[:unit])
  end
  
  # eg set_reps({ 'reps' => '10' })
  def set_reps(hsh)
    self.reps = indifferent_hsh(hsh)[:reps].to_i
  end
  
  # eg set_note({ 'note' => 'felt engaged' })
  def set_note(hsh)
    self.note = capitalize_str(indifferent_hsh(hsh)[:note])
  end
  
  private
    
    # 
    # Commands helpers
    # 
    def indifferent_hsh(hsh)
      hsh.is_a?(Hash) ? hsh.with_indifferent_access : {}
    end
    
    def capitalize_str(str)
      str.strip.capitalize
    end
  
    def titlecase_str(str)
      str.strip.titlecase
    end
  
    def normalize_duration(num, unit)
      num = num.to_i
      case unit
      when 'hr' then num.send(:hour)
      when 'min' then num.send(:minute)
      end
    end
    
    def normalize_distance(num, unit)
      num = num.to_f
      case unit
      when 'k' then 0.621371 * num # 1 k = 0.621371 mi
      when 'mi' then num
      end
    end
end
