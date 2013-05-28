# RulesEngine executes user created rules with the intention of parsing raw
# text messages into structured activity data.
#
# Rules have parent/child relationships. Executation starts with 'roots' (or
# rules without parent_ids) followed by recursing the immediate children of each
# rule in a depth-first-search fashion.
#
# Each rule is made of a command and optional arguments.
# A command prefixed with '.' (eg. '.match') is performed on raw text messages.
# A command prefixed with '#' (eg. '#set_name) is performed on activity model.
# 
# Users are free to create any rules they want, but they are limited to a
# predefined set of commands.
# '.' commands are native Ruby string methods as listed in Message::COMMANDS.
# '#' commands are custom ActiveRecord setters as listed in Activity::COMMANDS. 
class RulesEngine
  def initialize(message)
    @message = message
    @activity = Activity.new
    @rules = Rule.all
    @matches = nil
    execute(get_roots)
  end
  
  def execute(rules)
    rules.each do |rule|
      subject, method, arg = parse_rule(rule)
      retval = subject.send(method, arg)
      set_match_data(retval) if method == 'match'
      execute(get_children(rule)) if retval
    end
  end
  
  def preview_activity
    @activity.preview
  end
  
  def save_activity
    @activity.save
  end
  
  private
    def get_roots
      @rules.select { |rule| rule.parent_id.nil? }
    end
    
    def get_children(parent)
      @rules.select { |rule| rule.parent_id == parent.id }
    end
    
    def parse_rule(rule)
      case rule.command[0]
      when '.'
        subject = @message
        arg = rule.arg
      when '#'
        subject = @activity
        arg = rule.arg || @matches
      end
      method = rule.command[1..-1]
      [subject, method, arg]
    end
    
    def set_match_data(obj)
      @matches = obj.is_a?(MatchData) ? Hash[obj.names.zip(obj.captures)] : nil
    end
end
