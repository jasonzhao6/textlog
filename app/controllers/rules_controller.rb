class RulesController < ApplicationController
  before_filter :must_be_logged_in, only: [:create, :destroy, :update]
  
  def create
    @rule = matcher = Rule.new(matcher_params)
    if matcher.save
      # Create setters for matcher
      if matcher.valid? &&
         params[:commands].present? &&
         params[:commands].length == params[:args].length
      
        params[:commands].zip(params[:args]).map do |command, arg|
          Rule.create(command: command, arg: arg, matcher_id: matcher.id)
        end
      end
      
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
    @rule = Rule.find(params[:id])
  end
  
  def index
    @rules = Rule.order('updated_at DESC')
  end
  
  def new
    @rule = Rule.new
  end
  
  def update
    @rule = Rule.find(params[:id])
    if @rule.update_attributes(matcher_params)
      redirect_to :rules, notice: 'Rule was successfully updated.'
    else
      render action: :edit
    end
  end
  
  private
  
    def matcher_params
      params.require(:rule).permit(:command, :arg)
    end
end
