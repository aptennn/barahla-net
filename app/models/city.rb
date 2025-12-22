class City < ApplicationRecord
  self.primary_key = 'city_id'

  has_many :users, foreign_key: 'city_id', primary_key: 'city_id'

  validates :name, presence: true, uniqueness: { scope: [:region, :country] }
  validates :region, presence: true
  validates :country, presence: true

  def name_with_region
    "#{name}, #{region}"
  end

  def full_location
    "#{name}, #{region}, #{country}"
  end

  # Метод для поиска или создания города
  def self.find_or_create_by_attributes(attributes)
    city = find_by(
      name: attributes[:name],
      region: attributes[:region],
      country: attributes[:country]
    )

    city || create(attributes)
  end
end