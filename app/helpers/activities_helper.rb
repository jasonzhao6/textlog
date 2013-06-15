module ActivitiesHelper
  # 
  # Link helpers
  # 
  def top_activity_text(activity, count)
    "#{h(activity)} <sup>(#{h(count)})</sup>".html_safe
  end
  
  def top_activity_href(activity, _)
    activities_path(activity: activity)
  end
  
  def top_friend_text(_, name, count)
    "#{h(name)} <sup>(#{h(count)})</sup>".html_safe
  end
  
  def top_friend_href(fb_id, _, _)
    activities_path(friend: fb_id)
  end
  
  def top_friend_name(_, name, _)
    name
  end
  
  def activity_href(activity)
    activities_path(activity: activity)
  end
  
  def friend_href(fb_id)
    activities_path(friend: fb_id)
  end
  
  def profile_pic(fb_id, _ = nil, _ = nil)
    "http://graph.facebook.com/#{fb_id}/picture"
  end

  # 
  # Attribute helpers
  # 
  def dash_if_blank(attr)
    attr.blank? ? '-' : attr
  end
  
  def time_formatter(time)
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
