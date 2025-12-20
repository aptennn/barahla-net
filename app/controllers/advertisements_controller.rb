class AdvertisementsController < ApplicationController
  before_action :require_login
  before_action :set_advertisement, only: [:show, :edit, :update, :destroy]

  def new
    @advertisement = current_user.advertisements.new
    @categories = Advertisement::CATEGORIES
    @cities = City.all
  end

  def index
    @cities = City.all
    scope = Advertisement.includes(:user, :city).all

    # Основные фильтры
    scope = scope.where(category_id: params[:category_id]) if params[:category_id].present?
    scope = scope.where(city_id: params[:city_id]) if params[:city_id].present?
    scope = scope.where(status: params[:status]) if params[:status].present?

    # Ценовые фильтры
    if params[:min_price].present?
      scope = scope.where("price >= ?", params[:min_price].to_f)
    end
    if params[:max_price].present?
      scope = scope.where("price <= ?", params[:max_price].to_f)
    end

    # Фильтры по категориям
    scope = apply_category_filters(scope) if params[:category_id].present?

    @advertisements = scope.order(created_at: :desc).page(params[:page]).per(15)
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
          # Загрузка фотографий
          if params[:advertisement][:pictures].present?
            params[:advertisement][:pictures].each_with_index do |photo, index|
              @advertisement.advertisement_pictures.create(
                image: photo,
                position: index + 1
              )
            end
          end

          redirect_to my_advertisements_path, notice: 'Объявление успешно создано!'
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

  def edit
    @categories = Advertisement::CATEGORIES
    @cities = City.all

    @category_data = {}
    if @advertisement.category_detail
      case @advertisement.category_id
      when 1
        @category_data = @advertisement.transport.attributes.slice(
          'brand', 'model', 'year', 'mileage', 'fuel_type', 'transmission', 'engine_capacity'
        )
      when 2
        @category_data = @advertisement.real_estate.attributes.slice(
          'property_type', 'total_area', 'living_area', 'floor', 'total_floors', 'rooms_count'
        )
      when 3
        @category_data = @advertisement.service.attributes.slice('name')
      when 4
        @category_data = @advertisement.thing.attributes.slice('name', 'item_type')
      when 5
        @category_data = @advertisement.job.attributes.slice('name')
      end
    end
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

        # Добавление новых фотографий
        if params[:advertisement][:pictures].present?
          last_position = @advertisement.advertisement_pictures.maximum(:position) || 0
          params[:advertisement][:pictures].each_with_index do |photo, index|
            @advertisement.advertisement_pictures.create(
              image: photo,
              position: last_position + index + 1
            )
          end
        end

        # Удаление отмеченных фотографий
        if params[:advertisement][:delete_photos].present?
          params[:advertisement][:delete_photos].each do |photo_id|
            photo = @advertisement.advertisement_pictures.find_by(id: photo_id)
            photo&.destroy
          end
        end

        redirect_to my_advertisements_path, notice: "Объявление обновлено!"
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
      all_params.slice(
        'property_type', 'total_area', 'living_area', 'floor',
        'total_floors', 'rooms_count'
      )
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

  # Методы фильтрации (остаются без изменений)
  def apply_category_filters(scope)
    case params[:category_id].to_i
    when 1
      scope = apply_transport_filters(scope)
    when 2
      scope = apply_real_estate_filters(scope)
    when 3
      scope = apply_service_filters(scope)
    when 4
      scope = apply_thing_filters(scope)
    when 5
      scope = apply_job_filters(scope)
    end
    scope
  end

  def apply_transport_filters(scope)
    scope = scope.joins(:transport).where("transports.brand ILIKE ?", "%#{params[:brand]}%") if params[:brand].present?
    scope = scope.joins(:transport).where("transports.model ILIKE ?", "%#{params[:model]}%") if params[:model].present?

    if params[:year_from].present?
      scope = scope.joins(:transport).where("transports.year >= ?", params[:year_from].to_i)
    end

    if params[:year_to].present?
      scope = scope.joins(:transport).where("transports.year <= ?", params[:year_to].to_i)
    end

    scope = scope.joins(:transport).where(transports: { fuel_type: params[:fuel_type] }) if params[:fuel_type].present?
    scope = scope.joins(:transport).where(transports: { transmission: params[:transmission] }) if params[:transmission].present?

    if params[:mileage_to].present?
      scope = scope.joins(:transport).where("transports.mileage <= ?", params[:mileage_to].to_i)
    end

    scope
  end

  def apply_real_estate_filters(scope)
    scope = scope.joins(:real_estate).where(real_estates: { property_type: params[:property_type] }) if params[:property_type].present?
    scope = scope.joins(:real_estate).where(real_estates: { rooms_count: params[:rooms_count] }) if params[:rooms_count].present?

    if params[:total_area_from].present?
      scope = scope.joins(:real_estate).where("real_estates.total_area >= ?", params[:total_area_from].to_f)
    end

    if params[:total_area_to].present?
      scope = scope.joins(:real_estate).where("real_estates.total_area <= ?", params[:total_area_to].to_f)
    end

    if params[:floor_from].present?
      scope = scope.joins(:real_estate).where("real_estates.floor >= ?", params[:floor_from].to_i)
    end

    if params[:total_floors_from].present?
      scope = scope.joins(:real_estate).where("real_estates.total_floors >= ?", params[:total_floors_from].to_i)
    end

    scope
  end

  def apply_service_filters(scope)
    scope = scope.joins(:service).where("services.name ILIKE ?", "%#{params[:service_name]}%") if params[:service_name].present?
    scope
  end

  def apply_thing_filters(scope)
    scope = scope.joins(:thing).where("things.name ILIKE ?", "%#{params[:thing_name]}%") if params[:thing_name].present?
    scope = scope.joins(:thing).where(things: { item_type: params[:item_type] }) if params[:item_type].present?
    scope
  end

  def apply_job_filters(scope)
    scope = scope.joins(:job).where("jobs.name ILIKE ?", "%#{params[:job_name]}%") if params[:job_name].present?
    scope
  end

  def category_filters
    @category_id = params[:category_id]
    render template: "/filters/#{filter_template_name}", layout: false
  end

  private

  def filter_template_name
    case @category_id
    when "1" then "transport_filters"
    when "2" then "real_estate_filters"
    when "3" then "service_filters"
    when "4" then "thing_filters"
    when "5" then "job_filters"
    else "empty"
    end
  end
end