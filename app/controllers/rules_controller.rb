class RulesController < ApplicationController
  before_filter :must_be_logged_in, only: [:create, :destroy, :update]
  
  def create
    @rule = matcher = Rule.new(matcher_params)
    if matcher.save
      create_setters(matcher.id)
      
      redirect_to :rules, notice: 'Rule was successfully created.'
    else
      render action: :new
    end
  end
  
  def destroy
    Rule.find(params[:id]).destroy
    redirect_to :rules, alert: 'Rule was successfully deleted.'
  end
  
  def edit
    @rule = Rule.matchers.find(params[:id])
  end
  
  def index
    @rules = Rule.matchers
  end
  
  def new
    @rule = Rule.new
  end
  
  def update
    @rule = matcher = Rule.find(params[:id])
    if matcher.update_attributes(matcher_params)
      matcher.setters.destroy_all
      create_setters(matcher.id)
      
      redirect_to :rules, notice: 'Rule was successfully updated.'
    else
      render action: :edit
    end
  end
  
  private
    
    # 
    # Helpers
    # 
    def create_setters(matcher_id)
      if params[:commands].present? &&
         params[:commands].length == params[:args].length
      
        params[:commands].zip(params[:args]).map do |command, arg|
          Rule.create(command: command, arg: arg, matcher_id: matcher_id)
        end
      end
    end
    
    # 
    # Strong parameters
    # 
    def matcher_params
      params.require(:rule).permit(:command, :arg)
    end
end
