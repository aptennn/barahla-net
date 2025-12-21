require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = create_test_user
  end

  test "should get profile when logged in" do
    # Логиним пользователя
    log_in_as(@user)

    get profile_path
    assert_response :success
  end

  test "should redirect profile when not logged in" do
    get profile_path
    assert_redirected_to login_path
    assert_equal "Пожалуйста, войдите в систему", flash[:alert]
  end
end