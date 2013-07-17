class RulesController < ApplicationController
  before_filter :custom_redirect_path, only: [:bump, :create, :destroy, :edit,
                                              :new, :update]
  before_filter :must_be_logged_in, only: [:bump, :create, :destroy, :update]

  def bump
    Rule.find(params[:id]).touch
    redirect_to @redirect_path, notice: 'Rule was successfully bumped up.'
  end

  def create
    @rule = matcher = Rule.new(matcher_params)
    if matcher.valid? && setters_valid?
      matcher.save
      setters_create
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
    matcher.arg = params[:rule][:arg]
    if matcher.valid? && setters_valid?
      matcher.save
      matcher.setters.destroy_all
      setters_create
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
    def setters_valid?
      if params[:commands].nil? || params[:commands].join.blank?
        @rule.errors.add(:setter, "can't be blank") and return
      end

      params[:commands].zip(params[:args]).each do |command, arg|
        if command.present? && arg.blank?
          unless params[:rule][:arg].index("(?<#{command.split('_').last}>")
            @rule.errors.add(command, "can't be blank unless captured") and return
          end
        end
      end

      true
    end

    def setters_create
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
