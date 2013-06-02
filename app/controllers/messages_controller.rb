class MessagesController < ApplicationController
  before_filter :must_be_logged_in, only: [:create, :destroy, :update]
  skip_before_filter :verify_authenticity_token, only: :create # For Twillio
  
  def create
    # Twillio post
    if params['Body'].present?
      Message.create(message: params['Body'])
      render nothing: true
    # Web form post
    else
      @message = Message.new(message_params)
      if @message.save
        redirect_to :messages, notice: 'Message was successfully created.'
      else
        render action: :new
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
    @messages = Message.unparsed.order(:created_at)
  end
  
  def new
    @message = Message.new
  end
  
  def update
    @message = Message.find(params[:id])
    if @message.update_attributes(message_params)
      redirect_to :messages, notice: 'Message was successfully updated.'
    else
      render action: :edit
    end
  end
  
  private
  
    def message_params
      params.require(:message).permit(:message)
    end
end
