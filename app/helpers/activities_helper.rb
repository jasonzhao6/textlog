module ActivitiesHelper
  # 
  # Link helpers
  # 
  def activity_with_count(activity, count)
    "#{h(activity)} <sup>(#{h(count)})</sup>".html_safe
  end
  
  def activity_href(activity, _ = nil)
    activities_path(activity: activity)
  end
  
  def friend_with_count(_, name, count)
    "#{h(name)} <sup>(#{h(count)})</sup>".html_safe
  end
  
  def friend_href(fb_id, _ = nil, _ = nil)
    activities_path(friend: fb_id)
  end
  
  def profile_pic(fb_id, _ = nil, _ = nil)
    "https://graph.facebook.com/#{fb_id}/picture"
  end

  # 
  # Attribute helpers
  # 
  def dash_if_blank(attr)
    attr.blank? ? '-' : attr
  end
  
  def duration_formatter(time)
    if time.present?
      days = time / (60 * 60 * 24)
      hours = time / (60 * 60) % 24
      minutes = time / 60 % 60
      days_str = pluralize(days, 'day') if days > 0
      hours_str = "#{hours} hr" if hours > 0
      minutes_str = "#{minutes} min" if minutes > 0
      [days_str, hours_str, minutes_str].join(' ')
    end
  end
  
  def distance_formatter(distance)
    "#{distance} mi" if distance.present?
  end
end
