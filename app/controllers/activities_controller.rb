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
    @top_activities_as_hash = Activity.top_activities_as_hash
    @top_friends_as_hash = Activity.top_friends_as_hash
    
    @activities = if params[:primary_type].present? && params[:secondary_type].present?
                    Activity.index.where(primary_type: params[:primary_type],
                                         secondary_type: params[:secondary_type])
                  elsif params[:primary_type].present?
                    Activity.index.where(primary_type: params[:primary_type])
                  elsif params[:friend_id].present?
                    Friend.find(params[:friend_id]).activities.index
                  else
                    Activity.index
                  end
  end
end