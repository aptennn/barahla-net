class RealEstate < ApplicationRecord
  belongs_to :advertisement

  validates :total_area, numericality: { greater_than: 0 }
end