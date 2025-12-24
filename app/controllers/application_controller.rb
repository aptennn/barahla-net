class ApplicationController < ActionController::Base
  before_action :set_current_user
  before_action :require_login

  private

  def set_current_user
    if session[:user_id]
      @current_user = User.find_by(id: session[:user_id])
    end
  end

  def require_login
    unless @current_user
      redirect_to login_path, alert: "Пожалуйста, войдите в систему"
    end
  end

  def logged_in?
    @current_user.present?
  end
  helper_method :logged_in?

  def current_user
    @current_user
  end
  helper_method :current_user

end