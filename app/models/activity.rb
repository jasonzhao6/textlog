class Activity < ActiveRecord::Base
  belongs_to :message
  has_many :companies
  has_many :friends, through: :companies
  validates :primary_type, presence: true
  validates :message, presence: true
  
  # 
  # Rspec helpers
  # 
  def as_json(options = {})
    super(except: [:id, :message_id, :company_id],
          include: [friends: { except: [:id] }])
  end
  
  # 
  # Commands that can be called on activity models
  # 
  COMMANDS = ['set_primary_type',
              'set_secondary_type',
              'add_friend',
              'add_duration',
              'set_distance',
              'set_reps',
              'set_note']
  
  # eg set_primary_type({ 'primary_type' => 'biking' })
  def set_primary_type(arg)
    hsh = indifferent_hsh(arg)
    self.primary_type = titlecase_str(hsh[:primary_type])
  end
  
  # eg set_secondary_type({ 'secondary_type' => 'marin headlands' })
  def set_secondary_type(arg)
    hsh = indifferent_hsh(arg)
    self.secondary_type = titlecase_str(hsh[:secondary_type])
  end
  
  # eg add_friend({ 'name' => 'Somebody', 'fb_id' => 'somebody' })
  def add_friend(arg)
    hsh = indifferent_hsh(arg)
    friend = Friend.where(fb_id: hsh[:fb_id]).first_or_initialize
    friend.name = hsh[:name] # in case friend's name has been updated
    self.friends << friend unless self.friends.map(&:fb_id).include?(hsh[:fb_id])
  end
  
  # eg add_duration({ 'num' => '1', 'unit' => 'hr' })
  # eg add_duration({ 'num' => '44', 'unit' => 'min' })
  def add_duration(arg)
    hsh = indifferent_hsh(arg)
    duration = normalize_duration(hsh[:num], hsh[:unit])
    if duration
      self.duration ||= 0
      self.duration += duration
    end
  end
  
  # eg set_distance({ 'num' => '5', 'unit' => 'k' })
  # eg set_distance({ 'num' => '17.4', 'unit' => 'mi' })
  def set_distance(arg)
    hsh = indifferent_hsh(arg)
    distance = normalize_distance(hsh[:num], hsh[:unit])
    self.distance = distance if distance
  end
  
  # eg set_reps({ 'reps' => '10' })
  def set_reps(arg)
    hsh = indifferent_hsh(arg)
    self.reps = hsh[:reps].to_i
  end
  
  # eg set_note({ 'note' => 'felt engaged' })
  def set_note(arg)
    hsh = indifferent_hsh(arg)
    self.note = capitalize_str(hsh[:note])
  end
  
  private
    
    # 
    # Commands helpers
    # 
    def indifferent_hsh(arg)
      # 'arg' should be either a user entered string that can be evaled into a
      #       hash or a hash zipped from MatchData
      begin
        hsh = eval(arg) # TODO refactor this when other people can write rules
      rescue
        hsh = arg
      end
      hsh.with_indifferent_access rescue {}
    end
    
    def capitalize_str(str)
      str.strip.capitalize if str.present?
    end
  
    def titlecase_str(str)
      str.strip.titlecase if str.present?
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
