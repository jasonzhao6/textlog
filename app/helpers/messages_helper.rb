module MessagesHelper
  # 
  # Attribute helpers
  # 
  def dash_if_blank(attr)
    attr.blank? ? '-' : attr
  end
end
