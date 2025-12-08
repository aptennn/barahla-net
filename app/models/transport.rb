class Transport < ApplicationRecord
  self.primary_key = 'category_id'

  validates :brand, :model, presence: true

  def full_model_name
    "#{brand} #{model} #{year}"
  end
end