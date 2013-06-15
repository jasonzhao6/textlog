require 'yaml'

class Activity < ActiveRecord::Base
  belongs_to :message
  has_many :companies
  has_many :friends, through: :companies
  scope :index, -> { includes(:message, :friends)
                    .order('messages.created_at DESC, friends.name') }
  validates :activity, presence: true
  validates :message, presence: true
  
  # 
  # Presenters
  # 
  def activity_is_new?
    self.activity.present? &&
      Activity.find_by_activity(self.activity).nil?
  end
  
  # Returns an array of [activity, count] pairs
  # eg [['Biking', '3'], ['Climbing', '1']]
  def self.top_activities
    self.group(:activity)
        .order('SUM(1) DESC LIMIT 5')
        .sum(1)
        .map { |result| result.flatten }
  end

  # Returns an array of [id, name, count] triplets
  # eg [[1, 'Mary Ann Jawili', '3'], [5, 'Takashi Mizohata', '2']]
  def self.top_friends
    self.includes(:friends)
        .where('friend_id IS NOT NULL')
        .group('friends.fb_id', 'friends.name')
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
  
  # Takes hashes, string representation of hashes, and plain strings
  # eg set_activity({ activity: 'biking' })
  # eg set_activity('biking')
  def set_activity(arg)
    hsh = indifferent_hash(arg)
    self.activity = titlecase_str(hsh[:activity] || arg)
  end
  
  # Takes hashes, string representation of hashes, and plain strings
  # eg add_friend({ name: 'Lance Armstrong', fb_id: 'lancearmstrong' })
  # eg add_friend('Lance Armstrong, lancearmstrong')
  FRIEND_STR_SYNTAX = /^[^{:=>}]+,[^{:=>}]+$/
  def add_friend(arg)
    hsh = indifferent_hash(arg)
    
    # In case arg is a plain string shorthand for 'name, fb_id'
    if arg =~ FRIEND_STR_SYNTAX
      name, fb_id = arg.split(',').map(&:strip)
      hsh[:fb_id] ||= fb_id
      hsh[:name] ||= name
    end
    
    friend = Friend.where(fb_id: hsh[:fb_id]).first_or_initialize
    friend.name = hsh[:name] # In case friend's name has been updated
    self.friends << friend unless self.friends.map(&:fb_id).include?(hsh[:fb_id])
  end
  
  # Takes hashes and string representation of hashes
  # eg add_duration({ duration: '32', unit: 'min' })
  def add_duration(arg)
    hsh = indifferent_hash(arg)
    duration = normalize_duration(hsh[:duration], hsh[:unit])
    if duration
      self.duration ||= 0
      self.duration += duration
    end
  end
  
  # Takes hashes and string representation of hashes
  # eg set_distance({ distance: '17.4', unit: 'mi' })
  def set_distance(arg)
    hsh = indifferent_hash(arg)
    distance = normalize_distance(hsh[:distance], hsh[:unit])
    self.distance = distance if distance
  end
  
  # Takes hashes and string representation of hashes
  # eg set_reps({ reps: '10' })
  def set_reps(arg)
    hsh = indifferent_hash(arg)
    self.reps = hsh[:reps].to_i
  end
  
  # Takes hashes and string representation of hashes
  # eg set_note({ note: 'felt engaged' })
  def set_note(arg)
    hsh = indifferent_hash(arg)
    self.note = capitalize_str(hsh[:note])
  end
  
  private
    
    # 
    # Commands helpers
    # 
    OLD_HASH_SYNTAX = /:([\w\d]+)[\s]*=>/
    NEW_HASH_SYNTAX = '\1:'
    def indifferent_hash(arg)
      hsh = arg
      
      # In case arg is a string representation of hash
      if arg.is_a?(String)
        yml = arg.gsub(OLD_HASH_SYNTAX, NEW_HASH_SYNTAX).gsub('=>', ':')
        hsh = YAML.load(yml) rescue nil
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
