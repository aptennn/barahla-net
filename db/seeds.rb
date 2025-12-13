# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
cities = [
  [1, 'Ростов-на-Дону', 'Ростовская область', 'Россия'],
  [2, 'Краснодар', 'Краснодарский край', 'Россия'],
  [3, 'Сочи', 'Краснодарский край', 'Россия'],
  [4, 'Хадыженск', 'Краснодарский край', 'Россия'],
  [5, 'Батайск', 'Ростовская область', 'Россия']
]

cities.each do |city_id, name, region, country|
  City.find_or_create_by!(city_id: city_id) do |city|
    city.name = name
    city.region = region
    city.country = country
  end
end
