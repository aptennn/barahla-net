class Advertisement < ApplicationRecord
  self.primary_key = 'ad_id'

  belongs_to :user, foreign_key: 'user_id'
  belongs_to :city, foreign_key: 'city_id'

  def transport_detail
    Transport.find_by(category_id: category_id)
  end

  def real_estate_detail
    RealEstate.find_by(category_id: category_id)
  end

  def service_detail
    Service.find_by(category_id: category_id)
  end

  def job_detail
    Job.find_by(category_id: category_id)
  end

  def thing_detail
    Thing.find_by(category_id: category_id)
  end

  def details
    transport_detail || real_estate_detail || service_detail || thing_detail || job_detail
  end

  ## Обработка цены и статуса
  validates :price, numericality: { greater_than: 0 }
  validates :status, inclusion: { in: %w[active inactive sold reserved] }
  ## Возможность получать только активные объявления
  scope :active, -> { where(status: 'active') }
  scope :recent, -> { order(created_at: :desc) }


  ## Определяем тип объявления
  def ad_type
    case
      when transport_detail.present? then 'transport'
      when real_estate_detail.present? then 'real_estate'
      when service_detail.present? then 'service'
      when thing_detail.present? then 'thing'
      when job_detail.present? then 'job'
      else 'unknown'
    end
  end

end