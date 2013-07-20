class MessagesController < ApplicationController
  before_filter :must_be_logged_in, only: [:create, :destroy, :update]
  skip_before_filter :verify_authenticity_token, only: :create # For Twillio

  def create
    # When request comes from Twillio
    if params['Body'].present?
      Message.create(message: params['Body'])
      render nothing: true
    # When request comes locally
    else
      @message = Message.new(message_params)
      if @message.save
        redirect_to :messages, notice: 'Message was successfully created.'
      else
        render :new
      end
    end
  end

  def destroy
    Message.find(params[:id]).destroy
    redirect_to :messages, alert: 'Message was successfully deleted.'
  end

  def edit
    @message = Message.find(params[:id])
  end

  def index
    @messages = Message.unparsed
  end

  def new
    @message = Message.new
  end

  def show
    @message = Message.find(params[:id])
    @activity, @matchers_executed, @other_applicable_matchers = RulesEngine.new(@message).execute

    # Validate activity such that if there is any validation error, we can show
    # them now and have user correct them by editing rules.
    @activity.valid?

    # When a user clicks off to edit or add a rule, instruct rules controller
    # to return user back to this page.
    @redirect_path = message_path(@message)
  end

  def update
    @message = Message.find(params[:id])
    if @message.update_attributes(message_params)
      redirect_to :messages, notice: 'Message was successfully updated.'
    else
      render :edit
    end
  end

  private

    def message_params
      params.require(:message).permit(:message)
    end
end
