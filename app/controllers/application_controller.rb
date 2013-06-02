class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected
  
    # 
    # Session helpers
    # 
    def password
      ENV['TEXTLOG_PASSWORD']
    end
    def salt
      ENV['TEXTLOG_USERNAME']
    end
    def current_user?
      session[:current_user] == Digest::SHA1.hexdigest("#{password} #{salt}")
    end
    MUST_LOGIN = 'Sorry, only Jason has write access right now.'
    def must_be_logged_in
      redirect_to :login, alert: MUST_LOGIN and return unless current_user?
    end
    helper_method :current_user?
end
