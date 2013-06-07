class ActivitiesController < ApplicationController
  def create
    message = Message.find(params[:message_id])
    rules_engine = RulesEngine.new(message)
    rules_engine.execute
    rules_engine.save
    redirect_to :activities
  end
  
  def index
    @activities = Activity.includes(:message, :friends).all
  end
end
