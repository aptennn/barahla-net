class Review < ApplicationRecord
  belongs_to :author, class_name: 'User', foreign_key: :user_id
  belongs_to :recipient, class_name: 'User', foreign_key: :user_to_id

  validates :rating, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 1,
    less_than_or_equal_to: 5
  }
  validates :text, presence: true, length: { minimum: 5, maximum: 500 }

  validate :cannot_review_self

  private

  def cannot_review_self
    if user_id == user_to_id
      errors.add(:base, "Вы не можете оставить отзыв самому себе")
    end
  end
end