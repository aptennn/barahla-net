class Services < ApplicationRecord
  belongs_to :advertisement
  validates :name, presence: true
end
