class RulesEngine
  def initialize(message)
    # Parse a raw message
    @message = message        
    # ...into structured activity data
    @activity = Activity.new(message_id: message.id)
    # ...with user defined rules
    @matchers = Rule.matchers
    
    # MatchData zipped into a hash
    @match_data = nil         
  end
  
  # Returns [activity, applicable matchers]
  def execute
    # 1st pass: calling regex matchers on message model
    @matchers.each do |matcher|
      @match_data = zip_match_data(@message.match(matcher.arg))
      unless @match_data.nil?
        matcher.cnt += 1
        # 2nd pass: calling custom setters on activity model
        matcher.setters.each do |setter|
          @activity.send(setter.command,
                         setter.arg.present? ? setter.arg : @match_data)
          setter.cnt +=1
        end
      end
    end
    [@activity, Array(@matchers.select { |rule| rule.changed? })]
  end
  
  # Returns true or nil
  def save
    if @activity.save
      # In case 'cnt' has been incremented
      @matchers.each do |matcher|
        matcher.save if matcher.changed?
        matcher.setters.each { |setter| setter.save if setter.changed? }
      end
      true
    end
  end
  
  private
    
    def zip_match_data(data)
      data.nil? ? nil : Hash[data.names.zip(data.captures)]
    end
end
