class MessagesController < ApplicationController
  http_basic_authenticate_with name: ENV['TEXTLOG_USERNAME'],
                               password: ENV['TEXTLOG_PASSWORD'],
                               except: :create
  skip_before_filter :verify_authenticity_token, only: :create
  
  def create
    Message.create(body: params['Body'])
    render nothing: true
  end
  
  def edit
    @message = Message.find(params[:id])
  end
  
  def index
    @messages = Message.unparsed.order(:created_at).all
  end
  
  def update
    Message.find(params[:id]).update_attributes(message_params)
    redirect_to messages_path
  end
  
  private
  
    def message_params
      params.require(:message).permit(:body)
    end
end
