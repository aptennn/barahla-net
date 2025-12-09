class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.city_id ||= City.first&.id || 1
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice: "Аккаунт успешно создан!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
end