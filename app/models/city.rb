class City < ApplicationRecord
  self.primary_key = 'city_id'
  has_many :users
  has_many :advertisements

  ## Обработка полей
  validates :name, :region, :country, presence: true

  def full_name
    "#{name}, #{region}, #{country}"
  end
end