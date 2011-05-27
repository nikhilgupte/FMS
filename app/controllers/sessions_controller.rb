class SessionsController < ApplicationController
  before_filter :require_user, :only => :destroy

  def new
    session[:return_to] = params[:return_to] if params[:return_to].present?
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:success] = 'Logged in successfully.'
      redirect_back_or_default root_url
    else
      render :action => :new
    end
  end
  
  def destroy
    current_user_session.destroy
    reset_session
    flash[:success] = "Logged out successfully"
    redirect_back_or_default new_session_url
  end

end
