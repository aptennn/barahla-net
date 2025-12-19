class Thing < ApplicationRecord
  belongs_to :advertisement

  def display_name
    "#{name} (#{type})"
  end

  def category_type
    type
  end
end