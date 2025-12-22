class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  before_action :set_user, only: [:edit, :update]

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

  def edit
    @cities = City.all.order(:name)
  end

  def update
    if @user.update(user_update_params)
      redirect_to profile_path, notice: "Профиль успешно обновлен!"
    else
      @cities = City.all.order(:name)
      render :edit, status: :unprocessable_entity
    end
  end

  def profile
    @user = current_user
  end

  private

  def set_user
    @user = current_user
  end



  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end

  def user_update_params
    params.require(:user).permit(:username, :phone, :city_id)
  end
end