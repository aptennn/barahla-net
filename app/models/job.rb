class Job < ApplicationRecord
  self.primary_key = 'category_id'

  validates :name, presence: true
end