module RulesHelper
  # 
  # Heading helpers
  # 
  def rule_heading(matcher)
    verb = if matcher.created_at == matcher.updated_at
             'Created'
           elsif matcher.cnt_was_last_updated?
             'Used'
           else
             'Modified'
           end
    "#{verb} #{time_ago(matcher.updated_at)} ago | #{matcher.cnt}x"
  end
  
  # 
  # Link helpers
  # 
  def command_text(command, i)
    "#{command} <sup>(#{@command_counts[i]})</sup>".html_safe
  end

  def command_href(command)
    rules_path(command: command)
  end
end
