class MessagesController < ApplicationController
  http_basic_authenticate_with name: ENV['TEXTLOG_USERNAME'],
                               password: ENV['TEXTLOG_PASSWORD'],
                               except: :create
  skip_before_filter :verify_authenticity_token, only: :create
  
  def create
    Message.create(body: params['Body'])
    render nothing: true
  end
  
  def index
    @messages = Message.all
  end
end
