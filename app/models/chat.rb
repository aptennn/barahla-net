class Chat < ApplicationRecord
  belongs_to :advertisement, foreign_key: 'advertisement_id', primary_key: 'ad_id'
  belongs_to :ad_owner, class_name: 'User'
  belongs_to :user, class_name: 'User'
  has_many :messages, dependent: :destroy
end