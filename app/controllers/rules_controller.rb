class RulesController < ApplicationController
  before_filter :custom_redirect_path, only: [:create, :destroy, :edit, :new, :update]
  before_filter :must_be_logged_in, only: [:create, :destroy, :update]
  
  def create
    @rule = matcher = Rule.new(matcher_params)
    custom_validator
    if matcher.errors.empty? && matcher.save
      create_setters
      redirect_to @redirect_path, notice: 'Rule was successfully created.'
    else
      render action: :new
    end
  end
  
  def destroy
    Rule.find(params[:id]).destroy
    redirect_to @redirect_path, alert: 'Rule was successfully deleted.'
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
    custom_validator
    if matcher.errors.empty? && matcher.update_attributes(matcher_params)
      matcher.setters.destroy_all
      create_setters
      redirect_to @redirect_path, notice: 'Rule was successfully updated.'
    else
      render action: :edit
    end
  end
  
  private
    
    # 
    # Before filters
    # 
    def custom_redirect_path
      @redirect_path = params[:redirect_path] || :rules
    end
    
    # 
    # Helpers
    # 
    def create_setters
      if params[:commands].present? && params[:commands].length == params[:args].length
        params[:commands].zip(params[:args]).map do |command, arg|
          Rule.create(command: command, arg: arg, matcher_id: @rule.id)
        end
      end
    end

    def custom_validator
      if Message::COMMANDS.include?(params[:rule][:command]) && params[:rule][:arg].blank?
        @rule.errors.add(:arg, "can't be blank")
      end
    end
    
    # 
    # Strong parameters
    # 
    def matcher_params
      params.require(:rule).permit(:command, :arg)
    end
end
