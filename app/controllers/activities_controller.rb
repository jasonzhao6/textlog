class ActivitiesController < ApplicationController
  def create
    message = Message.find(params[:message_id])
    rules_engine = RulesEngine.new(message)
    rules_engine.execute
    if rules_engine.save
      redirect_to :activities
    else
      redirect_to message_path(message)
    end
  end
  
  def index
    # Sidebar
    @top_activities = Activity.top_activities
    @top_friends = Activity.top_friends
    
    # Main
    @activities = if params[:primary_type].present? && params[:secondary_type].present?
                    Activity.index.where(primary_type: params[:primary_type],
                                         secondary_type: params[:secondary_type])
                  elsif params[:primary_type].present?
                    Activity.index.where(primary_type: params[:primary_type])
                  elsif params[:friend].present?
                    Friend.find_by_name(params[:friend]).activities.index
                  else
                    Activity.index
                  end
  end
end