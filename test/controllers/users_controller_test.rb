require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @city = City.create!(
      city_id: 1,
      name: "Москва",
      region: "Московская область",
      country: "Россия"
    )
  end

  test "should get new registration page" do
    get register_path
    assert_response :success
  end

  test "should create user with valid data" do
    assert_difference('User.count', 1) do
      post register_path, params: {
        user: {
          username: "newuser",
          email: "new@example.com",
          password: "password123",
          password_confirmation: "password123"
        }
      }
    end
    assert_redirected_to root_path
    assert_equal "Аккаунт успешно создан!", flash[:notice]
  end

  test "should not create user with invalid data" do
    assert_no_difference('User.count') do
      post register_path, params: {
        user: {
          username: "",
          email: "invalid-email",
          password: "short",
          password_confirmation: "different"
        }
      }
    end
    assert_response :unprocessable_entity
  end
end