class Transport < ApplicationRecord
  belongs_to :advertisement
  validates :brand, :model, presence: true

  def full_model_name
    "#{brand} #{model} #{year}"
  end
end