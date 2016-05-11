class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :check_logged_in



  def check_logged_in

  	if session[:nick]
  		return true
  	else
  		redirect_to '/authenticate'
  		return false
  	end

  end
end
