module ActivitiesHelper
  def top_activity_text(k, v)
    "#{k.compact.join(' - ')} <sup>(#{v})</sup>".html_safe
  end
  
  def top_activity_href(k)
    hsh = { primary_type: k[0] }
    hsh[:secondary_type] = k[1] if k[1].present?
    activities_path(hsh)
  end
  
  def top_friend_text(k, v)
    "#{k.last} <sup>(#{v})</sup>".html_safe
  end
  
  def top_friend_href(k)
    activities_path(friend_id: k[0])
  end
end
