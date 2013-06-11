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
    if params['sort-by'] == 'most-frequently-used'
      "#{matcher.cnt}x | #{verb} #{time_ago(matcher.updated_at)} ago"
    else
      "#{verb} #{time_ago(matcher.updated_at)} ago | #{matcher.cnt}x"
    end
  end
  
  # 
  # Select helpers
  # 
  def sort_by_options
    [['Most recently used', nil],
     ['Most frequently used', 'most-frequently-used']]
  end
  
  # 
  # Link helpers
  # 
  def command_text(command, i)
    "#{command} <sup>(#{@command_counts[i]})</sup>".html_safe
  end

  def command_href(command)
    rules_path(command: command, 'sort-by' => params['sort-by'])
  end
end
