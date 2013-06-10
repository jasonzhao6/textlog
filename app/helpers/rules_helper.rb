module RulesHelper
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
