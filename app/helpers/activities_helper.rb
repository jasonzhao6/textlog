module ActivitiesHelper
  # 
  # Link helpers
  # 
  def top_activity_text(primary_type, secondary_type, count)
    type_text = [primary_type, secondary_type].compact.join(' - ')
    "#{type_text} <sup>(#{count})</sup>".html_safe
  end
  
  def top_activity_href(primary_type, secondary_type, count)
    activities_path(primary_type: primary_type,
                    secondary_type: secondary_type)
  end
  
  def top_friend_text(id, name, count)
    "#{name} <sup>(#{count})</sup>".html_safe
  end
  
  def top_friend_href(id, name, count)
    activities_path(friend: name)
  end
  
  def primary_type_href(primary_type)
    activities_path(primary_type: primary_type)
  end
  
  def secondary_type_href(activity)
    activities_path(primary_type: activity.primary_type,
                    secondary_type: activity.secondary_type)
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
