# RulesEngine executes user created rules with the intention of parsing raw
# text messages into structured activity data.
#
# Rules have parent/child relationships. Executation starts with 'roots' (or
# rules without parent_ids) followed by recursing the immediate children of each
# rule in a depth-first-search fashion.
#
# Each rule is made of a command and optional arguments.
# A command prefixed with '.' (eg. '.match' ) is performed on raw text messages.
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
    @match_data = nil
    get_roots.each { |rule| execute(rule) }
    preview
  end
  
  def execute(rule = nil)
    subject, method, arg = parse_rule(rule)
    retval = subject.send(method, arg)
    set_match_data(retval) if method == 'match'
    get_children(rule).each { |rule| execute(rule) }
  end
  
  def preview
    p @activity.to_json
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
        subject = @message.body
        arg = rule.args
      when '#'
        subject = @activity
        arg = rule.args || @match_data
      end
      method = rule.command[1..-1]
      [subject, method, arg]
    end
    
    def set_match_data(obj)
      @match_data = obj.nil? ? nil : Hash[obj.names.zip(obj.captures)]
    end
end
