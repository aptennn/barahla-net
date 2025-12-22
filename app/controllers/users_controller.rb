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
    @user = current_user
    @cities = City.all.order(:name)
    @new_city = City.new
  end

  def update
    @user = current_user
    if city_params_present?
      city = City.find_or_create_by_attributes(city_params)
      if city.persisted?
        @user.city_id = city.city_id
      else
        @user.errors.add(:base, "Не удалось создать город: #{city.errors.full_messages.join(', ')}")
      end
    end

    if @user.errors.empty? && @user.update(user_update_params)
      redirect_to profile_path, notice: "Профиль успешно обновлен!"
    else
      @cities = City.all.order(:name)
      @new_city = City.new
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end

  def user_update_params
    params.require(:user).permit(:username, :phone)
  end

  def city_params
    params.require(:city).permit(:name, :region, :country)
  end

  def city_params_present?
    params[:city] && params[:city][:name].present? &&
      params[:city][:region].present? && params[:city][:country].present?
  end
end