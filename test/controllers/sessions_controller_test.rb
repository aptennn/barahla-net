require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = create_test_user
  end

  test "should get login page" do
    get login_path
    assert_response :success
  end

  test "should create session with valid credentials" do
    post login_path, params: {
      email: @user.email,
      password: "password123"
    }

    assert_redirected_to root_path
    assert_equal "Вы успешно вошли в систему!", flash[:notice]
    assert logged_in?, "Пользователь должен быть авторизован"
  end

  test "should not create session with invalid credentials" do
    post login_path, params: {
      email: 'wrong@example.com',
      password: 'wrongpassword'
    }

    assert_response :unprocessable_entity
    assert_equal "Неверный email или пароль", flash[:alert]
    assert_not logged_in?, "Пользователь не должен быть авторизован"
  end

  test "should destroy session" do
    # Логиним пользователя
    post login_path, params: {
      email: @user.email,
      password: "password123"
    }
    assert logged_in?, "Пользователь должен быть авторизован"

    # Выходим
    delete logout_path
    assert_redirected_to login_path
    assert_equal "Вы вышли из системы", flash[:notice]
    assert_not logged_in?, "Пользователь должен быть разлогинен"
  end
end