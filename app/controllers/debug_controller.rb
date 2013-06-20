class DebugController < ApplicationController
  def index
    @activities = Activity.pluck(:activity).uniq.sort
    @friends = Friend.all.sort_by(&:name)
    @setters_without_matchers = Rule.where('matcher_id not in (?)',
                                           Rule.matchers.pluck(:id))
  end
end