module ActivitiesHelper
  # 
  # Link helpers
  # 
  def top_activity_text(activity, count)
    "#{h(activity)} <sup>(#{h(count)})</sup>".html_safe
  end
  
  def top_activity_href(activity, count)
    activities_path(activity: activity)
  end
  
  def top_friend_text(id, name, count)
    "#{h(name)} <sup>(#{h(count)})</sup>".html_safe
  end
  
  def top_friend_href(id, name, count)
    activities_path(friend: name)
  end
  
  def activity_href(activity)
    activities_path(activity: activity)
  end
  
  def friend_href(name)
    activities_path(friend: name)
  end

  # 
  # Attribute helpers
  # 
  def dash_if_blank(attr)
    attr.blank? ? '-' : attr
  end
  
  def time_formatter(time)
    if time.present?
      hours = time / (60 * 60)
      hours_str = "#{hours} hr" if hours > 0
      minutes = (time / 60) % 60
      minutes_str = "#{minutes} min" if minutes > 0
      [hours_str, minutes_str].join(' ')
    end
  end
  
  def distance_formatter(distance)
    "#{distance} mi" if distance.present?
  end
end
