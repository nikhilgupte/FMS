class ApplicationController < ActionController::Base
  before_filter :require_user, :set_time_zone
  protect_from_forgery

  #before_filter :require_user
  helper_method :current_user, :logged_in?

  private

  def set_time_zone
    Time.zone = current_user.time_zone if logged_in?
  end


  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end
  
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

  def logged_in?
    current_user.present?
  end

  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to new_session_url
      return false
    end
  end

  def store_location
    session[:return_to] = request.request_uri
  end
   
  def redirect_back_or_default(default)
    return_to = session.delete(:return_to)
    redirect_to(return_to || default)
  end

end
