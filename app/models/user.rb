class User < ApplicationRecord
  self.primary_key = 'id'
  has_secure_password
  belongs_to :city, foreign_key: 'city_id', primary_key: 'city_id'

  has_many :advertisements, foreign_key: 'id', dependent: :destroy
  has_many :chats_as_ad_owner, class_name: 'Chat', foreign_key: 'ad_owner_id', dependent: :destroy
  has_many :chats_as_user, class_name: 'Chat', foreign_key: 'user_id', dependent: :destroy
  has_many :sent_messages, class_name: 'Message', foreign_key: 'sender_id', dependent: :destroy
  has_many :received_messages, class_name: 'Message', foreign_key: 'receiver_id', dependent: :destroy

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