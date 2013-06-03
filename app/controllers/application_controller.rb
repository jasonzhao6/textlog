class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  # 
  # Actions
  # 
  def root
    redirect_to :activities
  end

  # 
  # Session helpers
  # 
  def set_current_user
    session[:current_user] = ENV['TEXTLOG_PASSWORD']
  end
  
  helper_method :current_user?
  def current_user?
    session[:current_user] == ENV['TEXTLOG_PASSWORD']
  end
    
  private
  
    # 
    # Before filters
    # 
    LOGIN_FAILED = 'Sorry, only Jason has write access right now.'
    def must_be_logged_in
      redirect_to :login, alert: LOGIN_FAILED and return unless current_user?
    end
end
