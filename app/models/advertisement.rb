class Advertisement < ApplicationRecord
  self.primary_key = 'ad_id'

  belongs_to :user, foreign_key: 'user_id', optional: true
  belongs_to :city, foreign_key: 'city_id'

  ## Одна из записей будет заполнена в зависимости от значения category_id
  has_one :transport, dependent: :destroy
  has_one :real_estate, dependent: :destroy
  has_one :service, dependent: :destroy
  has_one :thing, dependent: :destroy
  has_one :job, dependent: :destroy

  CATEGORIES = {
    1 => 'Транспорт',
    2 => 'Недвижимость',
    3 => 'Услуги',
    4 => 'Вещи',
    5 => 'Работа'
  }.freeze

  def category_detail
    case category_id
    when 1 then transport
    when 2 then real_estate
    when 3 then service
    when 4 then thing
    when 5 then job
    end
  end

  ## Обработка цены и статуса
  validates :price, numericality: { greater_than: 0 }
  validates :status, inclusion: { in: %w[active inactive sold reserved] }
  validates :category_id, inclusion: { in: 1..5 }
  ## Возможность получать только активные объявления
  scope :active, -> { where(status: 'active') }
  scope :recent, -> { order(created_at: :desc) }


  ## Определяем тип объявления
  def ad_type
    case category_id
    when 1 then 'transport'
    when 2 then 'real_estate'
    when 3 then 'service'
    when 4 then 'thing'
    when 5 then 'job'
    else 'unknown'
    end
  end

  def build_category_detail(params = {})
    case category_id
    when 1 then build_transport(params)
    when 2 then build_real_estate(params)
    when 3 then build_service(params)
    when 4 then build_thing(params)
    when 5 then build_job(params)
    end
  end

end