class RulesEngine
  def initialize(message)
    # Parse a message
    @message = message
    # ...into structured data
    @activity = Activity.new(message_id: message.id)
    # ...with user defined rules
    @matchers = Rule.matchers
  end
  
  # Returns [activity, matchers executed, other applicable matchers]
  def execute
    # States for this execution
    applicable_matchers = []
    matchers_executed = []
    commands_executed = {}
    
    # Loop through each matcher
    @matchers.each do |matcher|
      
      # States for this matcher
      setter_executed = false
      matches = @message.match(matcher.arg)
      
      # If there was a match
      if matches
        applicable_matchers << matcher
        matches_hsh = Hash[matches.names.zip(matches.captures)]
        
        # Loop through each setter
        matcher.setters.each do |setter|
          
          # Do not execute the same set_* command twice
          unless commands_executed[setter.command]
            if setter.command =~ /^set_/
              commands_executed[setter.command] = true
            end
            
            # Execute 
            @activity.send(setter.command,
                           setter.arg.present? ? setter.arg : matches_hsh)
            setter_executed = true
            setter.cnt += 1
          end
        end
        
        # If at least one setter executed
        if setter_executed
          matchers_executed << matcher
          matcher.cnt += 1
        end
      end
    end
    
    [@activity, matchers_executed, applicable_matchers - matchers_executed]
  end
  
  # Returns true or nil
  def save
    if @activity.save
      # Update setters and matchers who 'cnt' has changed
      @matchers.each do |matcher|
        if matcher.cnt_changed?
          matcher.save
          matcher.setters.each { |setter| setter.save if setter.cnt_changed? }
        end
      end
      return true
    end
  end
end
