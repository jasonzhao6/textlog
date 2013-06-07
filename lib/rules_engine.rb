class RulesEngine
  def initialize(message)
    # Parse a raw message
    @message = message        
    # into structured activity data
    @activity = Activity.new(message_id: message.id)
    # with user defined rules
    @rules = Rule.matchers
    
    # MatchData zipped into a hash
    @match_data = nil         
  end
  
  # returns [@activity, @rules (matched only)]
  def execute
    # 1st pass: calling regex matchers on message model
    @rules.each do |matcher|
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
    [@activity, Array(@rules.select { |rule| rule.changed? })]
  end
  
  def save
    @activity.save
    @rules.each do |matcher|
      # 'cnt' may have changed
      matcher.save if matcher.changed?
      matcher.setters.each { |setter| setter.save if setter.changed? }
    end
  end
  
  private
    
    def zip_match_data(data)
      data.nil? ? nil : Hash[data.names.zip(data.captures)]
    end
end
