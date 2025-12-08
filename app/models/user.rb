class User < ApplicationRecord
  self.primary_key = 'user_id'
  has_secure_password
  belongs_to :city, foreign_key: 'city_id'

  has_many :advertisements, foreign_key: 'user_id', dependent: :destroy

  validates :email,
            presence: true,
            uniqueness: true,
            format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :username,
            presence: true,
            uniqueness: true,
            length: { minimum: 3, maximum: 50 }

  validates :password,
            length: { minimum: 6 },
            if: -> { new_record? || !password.nil? }
end