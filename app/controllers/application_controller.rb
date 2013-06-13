require 'lookup_tables'
require 'rules_engine'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  # 
  # Controller actions
  # 
  def root
    redirect_to :messages
    # TODO landing page with messages via text + rules = activities
    #      how to write rules with/out regex
    #      explain structure of activities
    # maybe recommend typing 'bik' instead of 'biking|biked'
    #             and typing 'butter' insead of 'butterlap|butter lap'
  end

  # 
  # Session helpers
  # 
  helper_method :current_user?
  def current_user?
    session[:current_user] == ENV['TEXTLOG_PASSWORD']
  end
  
  def set_current_user
    session[:current_user] = ENV['TEXTLOG_PASSWORD']
  end

  # 
  # About this request
  # 
  def twillio_request?
    params['Body'].present?
  end
    
  protected
  
    # 
    # Before filters
    # 
    LOGIN_FAILED = 'Sorry, only Jason has write access right now.'
    def must_be_logged_in
      unless current_user? || twillio_request?
        redirect_to :login, alert: LOGIN_FAILED and return
      end
    end
end
