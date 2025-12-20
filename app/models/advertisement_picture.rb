class AdvertisementPicture < ApplicationRecord
  belongs_to :advertisement, foreign_key: 'ad_id', primary_key: 'ad_id'
  has_one_attached :image

  validate :validate_image

  before_create :set_default_position

  def thumbnail
    return unless image.attached?
    image.variant(resize_to_limit: [300, 300])
  end

  def medium
    return unless image.attached?
    image.variant(resize_to_limit: [800, 800])
  end

  private

  def validate_image
    return unless image.attached?

    unless image.content_type.in?(%w[image/png image/jpeg image/jpg image/gif])
      errors.add(:image, 'Должно быть изображение PNG, JPEG, JPG или GIF')
    end

    if image.blob.byte_size > 5.megabytes
      errors.add(:image, 'Размер изображения не должен превышать 5MB')
    end
  end

  def set_default_position
    if position.nil?
      last_position = AdvertisementPicture.where(ad_id: ad_id).maximum(:position) || 0
      self.position = last_position + 1
    end
  end
end