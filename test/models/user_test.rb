require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @city = create_test_city
    @user = User.new(
      username: "validuser",
      email: "valid@example.com",
      password: "password123",
      password_confirmation: "password123",
      city_id: @city.city_id
    )
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "username should be present" do
    @user.username = "     "
    assert_not @user.valid?
    assert_includes @user.errors[:username], "can't be blank"
  end

  test "username should be unique" do
    @user.save
    duplicate_user = User.new(
      username: "validuser",
      email: "other@example.com",
      password: "password123",
      password_confirmation: "password123",
      city_id: @city.city_id
    )
    assert_not duplicate_user.valid?
  end

  test "email should be present and valid" do
    @user.email = "     "
    assert_not @user.valid?

    @user.email = "invalid-email"
    assert_not @user.valid?
  end

  test "password should have minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
end