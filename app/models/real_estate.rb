class RealEstate < ApplicationRecord
  self.primary_key = 'category_id'

  validates :total_area, numericality: { greater_than: 0 }
end