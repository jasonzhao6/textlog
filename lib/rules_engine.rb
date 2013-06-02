class RulesEngine
  def initialize(message)
    @message = message       # Parse a raw message
    @activity = Activity.new # ...into structured activity data
    @rules = Rule.all        # ...with user defined rules
    @match_data = nil        # MatchData zipped into a hash
    execute
  end
  
  def execute
    # 1st pass: calling regex matchers on message model
    get_matchers.each do |matcher|
      @match_data = zip_match_data(@message.match(matcher.arg))
      unless @match_data.nil?
        matcher.bump
        # 2nd pass: calling custom setters on activity model
        get_setters(matcher).each do |setter|
          @activity.send(setter.command, setter.arg || @match_data)
          setter.bump
        end
      end
    end
  end
  
  def preview_activity
    @activity.preview
  end
  
  def save_activity
    @activity.save
  end
  
  private
    def get_matchers
      @rules.select { |rule| rule.parent_id.nil? }
    end
    
    def get_setters(matcher)
      @rules.select { |rule| rule.parent_id == matcher.id }
    end
    
    def zip_match_data(data)
      data.nil? ? nil : Hash[data.names.zip(data.captures)]
    end
end
