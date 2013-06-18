class RulesController < ApplicationController
  before_filter :custom_redirect_path, only: [:bump, :create, :destroy, :edit, :new, :update]
  before_filter :must_be_logged_in, only: [:bump, :create, :destroy, :update]
  
  def bump
    Rule.find(params[:id]).touch
    redirect_to @redirect_path, notice: 'Rule was successfully bumped up.'
  end
  
  def create
    @rule = matcher = Rule.new(matcher_params)
    if matcher.save
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
    # Sidebar
    @command_counts = Activity::COMMANDS.map do |command|
                        Rule.matchers_for(command).count
                      end
    
    # Main
    @rules = if params[:command].present?
               Rule.matchers_for(params[:command])
             else
               Rule.matchers
             end
    if params['sort-by'] == 'most-frequently-used'
      @rules = @rules.order('rules.cnt DESC')
    end

    # When a user clicks off to edit a rule, instruct edit form to preserve
    # filter/sort params when redirecting user back.
    @redirect_path = rules_path(command: params[:command],
                                'sort-by' => params['sort-by'])
  end
  
  def new
    @rule = Rule.new
    @message = Message.find(params[:message_id]) if params[:message_id]
  end
  
  def update
    @rule = matcher = Rule.find(params[:id])
    if matcher.update_attributes(matcher_params)
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
      if params[:commands].present?
        params[:commands].zip(params[:args]).map do |command, arg|
          Rule.create(command: command, arg: arg, matcher_id: @rule.id)
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
