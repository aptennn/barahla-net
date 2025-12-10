class AdvertisementsController < ApplicationController
  before_action :require_login
  before_action :set_advertisement, only: [:show, :edit, :update, :destroy]
  def new
    @advertisement = current_user.advertisements.new
    @categories = Advertisement::CATEGORIES
    @cities = City.all
  end

  # Главная страница
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
      redirect_to advertisement_path, notice: "Объявление обновлено!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @advertisement.destroy
    redirect_to advertisement_path, notice: 'Объявление удалено!'
  end

  def my
    @advertisements = current_user.advertisements.recent
  end

  private
  def ad_params
    params.require(:advertisement).permit(:title, :description, :price, :status, :category_id)
  end

  def set_advertisement
    @advertisement = Advertisement.find(params[:id])
  end

end