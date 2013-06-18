class RulesEngine
  def initialize(message)
    # Parse a message
    @message = message
    # ...into structured data
    @activity = Activity.new(message_id: message.id)
    # ...with user defined rules
    @matchers = Rule.matchers
  end
  
  # Returns [activity, applicable matchers]
  def execute
    already_set = {}
    @matchers.each do |matcher|
      matched_and_set = false
      matches = @message.match(matcher.arg)
      if matches
        matches_hsh = Hash[matches.names.zip(matches.captures)]
        matcher.setters.each do |setter|
          unless already_set[setter.command]
            already_set[setter.command] = true if setter.command =~ /^set_/
            @activity.send(setter.command,
                           setter.arg.present? ? setter.arg : matches_hsh)
            setter.cnt += 1
            matched_and_set = true
          end
        end
        matcher.cnt += 1 if matched_and_set
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
end
