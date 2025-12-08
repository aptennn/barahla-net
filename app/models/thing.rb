class Thing < ApplicationRecord
  self.primary_key = 'category_id'

  def display_name
    "#{name} (#{type})"
  end

  def category_type
    type
  end
end