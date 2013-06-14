class Activity < ActiveRecord::Base
  belongs_to :message
  has_many :companies
  has_many :friends, through: :companies
  scope :index, -> { includes(:message, :friends)
                    .order('messages.created_at DESC') }
  validates :activity, presence: true
  validates :message, presence: true
  
  # 
  # Presenters
  # 
  def activity_is_new?
    self.activity.present? &&
      Activity.find_by_activity(self.activity).nil?
  end
  
  # Returns array of [activity, count]
  # eg [["Biking", "3"], ["Climbing", "1"]]
  def self.top_activities
    self.group(:activity)
        .order('SUM(1) DESC LIMIT 5')
        .sum(1)
        .map { |result| result.flatten }
  end

  # Returns array of [id, name, count]
  # eg [[1, "Mary Ann Jawili", "3"], [5, "Takashi Mizohata", "2"]]
  def self.top_friends
    self.includes(:friends)
        .where('friend_id IS NOT NULL')
        .group(:friend_id, 'friends.name')
        .references(:friends)
        .order('SUM(1) DESC LIMIT 5')
        .sum(1)
        .map { |result| result.flatten }
  end
 
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
  COMMANDS = ['set_activity',
              'add_friend',
              'add_duration',
              'set_distance',
              'set_reps',
              'set_note']
  
  # eg set_activity('biking')
  # eg set_activity({ activity: 'biking' })
  def set_activity(arg)
    hsh = indifferent_hash(arg)
    self.activity = titlecase_str(hsh[:activity] || arg)
  end
  
  # eg add_friend('Lance Armstrong, lancearmstrong')
  # eg add_friend({ name: 'Lance Armstrong', fb_id: 'lancearmstrong' })
  HASH_SYNTAX = /[{:=>}]/
  def add_friend(arg)
    hsh = indifferent_hash(arg)
    if hsh.blank? && arg.is_a?(String) && arg !=~ HASH_SYNTAX
      name, fb_id = arg.split(',').map(&:strip)
      hsh[:fb_id] ||= fb_id
      hsh[:name] ||= name
    end
    friend = Friend.where(fb_id: hsh[:fb_id]).first_or_initialize
    friend.name = hsh[:name] # in case friend's name has been updated
    self.friends << friend unless self.friends.map(&:fb_id).include?(hsh[:fb_id])
  end
  
  # eg add_duration({ duration: '1', unit: 'hr' })
  # eg add_duration({ duration: '44', unit: 'min' })
  def add_duration(arg)
    hsh = indifferent_hash(arg)
    duration = normalize_duration(hsh[:duration], hsh[:unit])
    if duration
      self.duration ||= 0
      self.duration += duration
    end
  end
  
  # eg set_distance({ distance: '5', unit: 'k' })
  # eg set_distance({ distance: '17.4', unit: 'mi' })
  def set_distance(arg)
    hsh = indifferent_hash(arg)
    distance = normalize_distance(hsh[:distance], hsh[:unit])
    self.distance = distance if distance
  end
  
  # eg set_reps({ reps: '10' })
  def set_reps(arg)
    hsh = indifferent_hash(arg)
    self.reps = hsh[:reps].to_i
  end
  
  # eg set_note({ note: 'felt engaged' })
  def set_note(arg)
    hsh = indifferent_hash(arg)
    self.note = capitalize_str(hsh[:note])
  end
  
  private
    
    # 
    # Commands helpers
    # 
    def indifferent_hash(arg)
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
      if str.present?
        str.strip!
        str[0] = str[0].capitalize
        str
      end
    end
  
    def titlecase_str(str)
      str.strip.titlecase if str.present?
    end
  
    def normalize_duration(duration, unit)
      duration = duration.to_i
      case unit
      when 'hr', 'hrs', 'hour', 'hours' then duration.send(:hour)
      when 'min', 'minute', 'minutes' then duration.send(:minute)
      end
    end
    
    def normalize_distance(distance, unit)
      distance = distance.to_f
      case unit
      when 'k' then 0.621371 * distance # 1 k = 0.621371 mi
      when 'mi', 'mile', 'miles' then distance
      end
    end
end
