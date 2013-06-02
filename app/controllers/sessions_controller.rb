class SessionsController < ApplicationController
  def create
    if params[:password] == ENV['TEXTLOG_PASSWORD']
      session[:current_user] = Digest::SHA1.hexdigest("#{password} #{salt}")
      redirect_to :messages
    else
      redirect_to :login, alert: 'Password was incorrect.'
    end
  end
  
  def destroy
    reset_session
    redirect_to :login
  end
  
  def new
    redirect_to :messages and return if current_user?
  end
end
