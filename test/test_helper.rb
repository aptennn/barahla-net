ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors, with: :threads)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.


    # Add more helper methods to be used by all tests here...
    # Метод для создания тестового города
    def create_test_city(city_id = 1)
      City.find_or_create_by!(city_id: city_id) do |city|
        city.name = "Тестовый город"
        city.region = "Тестовый регион"
        city.country = "Россия"
      end
    end

    # Метод для создания тестового пользователя
    def create_test_user(username: "testuser", email: "test@example.com", city_id: 1)
      # Сначала создаем город если его нет
      city = City.find_by(city_id: city_id)
      city ||= create_test_city(city_id)

      User.create!(
        username: username,
        email: email,
        password: "password123",
        password_confirmation: "password123",
        city_id: city.city_id
      )
    end

    # Хелпер для входа пользователя
    def log_in_as(user)
      post login_path, params: {
        email: user.email,
        password: "password123"
      }
    end

    # Проверка авторизации
    def logged_in?
      !session[:user_id].nil?
    end
  end
end
