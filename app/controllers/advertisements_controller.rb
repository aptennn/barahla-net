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
    all_params = params.require(:advertisement).to_unsafe_h

    ad_params = all_params.slice(
      'title', 'description', 'price', 'status',
      'category_id', 'city_id'
    )

    @advertisement = Advertisement.new(ad_params)
    @advertisement.user_id = current_user.id

    if @advertisement.category_id.present?
      category_params = extract_category_params(@advertisement.category_id, all_params)
      @advertisement.build_category_detail(category_params)
    end

    ActiveRecord::Base.transaction do
      if @advertisement.save
        if @advertisement.category_detail&.save
          redirect_to advertisement_path(@advertisement), notice: 'Объявление успешно создано!'
          return
        else
          raise ActiveRecord::Rollback
        end
      else
        raise ActiveRecord::Rollback
      end
    end

    @categories = Advertisement::CATEGORIES
    @cities = City.all
    render :new, status: :unprocessable_entity
  end

  def show
  end

  def edit
    @categories = Advertisement::CATEGORIES
    @cities = City.all
  end

  def update
    all_params = params.require(:advertisement).to_unsafe_h

    ad_params = all_params.slice(
      'title', 'description', 'price', 'status',
      'category_id', 'city_id'
    )

    ActiveRecord::Base.transaction do
      if @advertisement.update(ad_params)
        category_params = extract_category_params(@advertisement.category_id, all_params)

        if @advertisement.category_detail
          @advertisement.category_detail.update(category_params)
        else
          @advertisement.build_category_detail(category_params)
          @advertisement.category_detail.save
        end

        redirect_to advertisement_path(@advertisement), notice: "Объявление обновлено!"
        return
      else
        raise ActiveRecord::Rollback
      end
    end

    @categories = Advertisement::CATEGORIES
    @cities = City.all
    render :edit, status: :unprocessable_entity
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
    params.require(:advertisement).permit(
      :title, :description, :price, :status,
      :category_id, :city_id
    )
  end

  def extract_category_params(category_id, all_params)
    case category_id
    when 1
      all_params.slice(
        'brand', 'model', 'year', 'mileage', 'fuel_type',
        'transmission', 'engine_capacity'
      )
    when 2
      params = all_params.slice(
        'property_type', 'total_area', 'living_area', 'floor',
        'total_floors', 'rooms_count'
      )
      params
    when 3
      all_params.slice('name')
    when 4
      all_params.slice('name', 'item_type')
    when 5
      all_params.slice('name')
    else
      {}
    end
  end

  def set_advertisement
    @advertisement = Advertisement.find(params[:id])
  end
end