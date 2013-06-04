class RulesEngine
  def initialize(message)
    @message = message       # Parse a raw message
    @activity = Activity.new # ...into structured activity data
    @rules = Rule.all        # ...with user defined rules
    @match_data = nil        # MatchData zipped into a hash
  end
  
  def execute
    # 1st pass: calling regex matchers on message model
    Rule.get_matchers(@rules).each do |matcher|
      @match_data = zip_match_data(@message.match(matcher.arg))
      unless @match_data.nil?
        matcher.cnt += 1
        # 2nd pass: calling custom setters on activity model
        Rule.get_setters(@rules, matcher).each do |setter|
          @activity.send(setter.command, setter.arg || @match_data)
          setter.cnt +=1
        end
      end
    end
  end
  
  def preview
    @activity.preview
  end
  
  def save
    @activity.save
    @rules.each { |rule| rule.save if rule.changed? } # 'cnt' may have changed
  end
  
  private
  
    def zip_match_data(data)
      data.nil? ? nil : Hash[data.names.zip(data.captures)]
    end
end
