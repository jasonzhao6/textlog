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
    @activities = Activity.includes(:message, :friends)
                          .order('messages.created_at DESC')
  end
end
