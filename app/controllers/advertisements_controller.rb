class AdvertisementsController < ApplicationController
  before_action :require_login
  before_action :set_advertisement, only: [:show, :edit, :update, :destroy]

  def new
    @advertisement = current_user.advertisements.new
    @categories = Advertisement::CATEGORIES
    @cities = City.all
  end

  def index
    @advertisements = Advertisement.includes(:user).recent
    @my_advertisements = current_user.advertisements.recent if logged_in?
  end

  def create
    @advertisement = current_user.advertisements.new(ad_params)
    if @advertisement.save
      redirect_to advertisement_path(@advertisement), notice: 'Объявление успешно создано!'
    else
      @categories = Advertisement::CATEGORIES
      @cities = City.all
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
    @categories = Advertisement::CATEGORIES
    @cities = City.all
  end

  def update
    if @advertisement.update(ad_params)
      redirect_to advertisement_path(@advertisement), notice: "Объявление обновлено!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @advertisement.destroy
    redirect_to advertisements_path, notice: 'Объявление удалено!'
  end

  def my
    @advertisements = Advertisement.where(user_id: current_user.id).order(created_at: :desc)
  end

  private

  def ad_params
    permitted = [:title, :description, :price, :status, :category_id, :city_id]
    category_id = params[:advertisement][:category_id].to_i if params[:advertisement]

    case category_id
    when 1
      permitted += [:brand, :model, :year, :mileage, :fuel_type, :transmission, :engine_capacity]
    when 2
      permitted += [:area, :rooms, :floor, :building_type]
    when 3
      permitted += [:service_type, :experience, :availability]
    when 4
      permitted += [:condition, :brand, :size, :color]
    when 5
      permitted += [:position, :employment_type, :schedule, :experience_required]
    end

    params.require(:advertisement).permit(*permitted)
  end

  def set_advertisement
    @advertisement = Advertisement.find(params[:id])
  end
end