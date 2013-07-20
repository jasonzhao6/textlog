module ApplicationHelper
  #
  # Native helper wrappers
  #

  # Drop the 'about' and 'less than' from what `time_ago_in_words` returns
  def time_ago(time)
    time_ago_in_words(time).gsub(/(about|less than) /, '')
  end
end
