class ApplicationController < ActionController::Base
  protect_from_forgery
  
  protected
  
  def confirm_logged_in
    unless session[:user_id]
      flash[:notice] = "Please log in."
      redirect_to(:controller => 'lists', :action => 'login')
      return false #Halts the login
    else
      return true
    end
  end
  
end
