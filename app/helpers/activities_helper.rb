module ActivitiesHelper
  def activity_attr(attr)
    attr.present? ? attr : '-'
  end
end
