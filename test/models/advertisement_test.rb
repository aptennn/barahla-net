require "test_helper"

class AdvertisementTest < ActiveSupport::TestCase
  def setup
    @city = City.create!(
      city_id: 1,
      name: "Москва",
      region: "Московская область",
      country: "Россия"
    )

    @user = User.create!(
      username: "seller",
      email: "seller@example.com",
      password: "password123",
      password_confirmation: "password123",
      city_id: @city.city_id
    )

    @ad = Advertisement.new(
      ad_id: 1,
      title: "Продам машину",
      description: "Хорошая машина",
      price: 100000,
      status: "active",
      category_id: 1,
      city_id: @city.city_id,
      user_id: @user.id
    )
  end

  test "should be valid" do
    assert @ad.valid?
  end

  test "should require title" do
    @ad.title = nil
    assert_not @ad.valid?
  end

  test "should require description" do
    @ad.description = nil
    assert_not @ad.valid?
  end

  test "price should be positive" do
    @ad.price = 0
    assert_not @ad.valid?
    @ad.price = -100
    assert_not @ad.valid?
  end

  test "status should be valid" do
    valid_statuses = %w[active inactive sold reserved]
    valid_statuses.each do |status|
      @ad.status = status
      assert @ad.valid?, "Status #{status} should be valid"
    end
  end

  test "status should not be invalid" do
    @ad.status = "invalid_status"
    assert_not @ad.valid?
  end

  test "category_id should be between 1 and 5" do
    (1..5).each do |category_id|
      @ad.category_id = category_id
      assert @ad.valid?, "category_id #{category_id} should be valid"
    end
  end

  test "category_id should not be outside range" do
    @ad.category_id = 0
    assert_not @ad.valid?
    @ad.category_id = 6
    assert_not @ad.valid?
  end

  test "should belong to city" do
    @ad.save
    assert_equal @city, @ad.city
  end

  test "should belong to user" do
    @ad.save
    assert_equal @user, @ad.user
  end

  test "scope active should return only active ads" do
    active_ad = Advertisement.create!(
      ad_id: 2,
      title: "Активное объявление",
      description: "Описание",
      price: 50000,
      status: "active",
      category_id: 2,
      city_id: @city.city_id,
      user_id: @user.id
    )

    inactive_ad = Advertisement.create!(
      ad_id: 3,
      title: "Неактивное объявление",
      description: "Описание",
      price: 50000,
      status: "inactive",
      category_id: 2,
      city_id: @city.city_id,
      user_id: @user.id
    )

    assert_includes Advertisement.active, active_ad
    assert_not_includes Advertisement.active, inactive_ad
  end

  test "scope recent should order by created_at desc" do
    ad1 = Advertisement.create!(
      ad_id: 4,
      title: "Первое",
      description: "Описание",
      price: 1000,
      status: "active",
      category_id: 1,
      city_id: @city.city_id,
      user_id: @user.id,
      created_at: 1.day.ago
    )

    ad2 = Advertisement.create!(
      ad_id: 5,
      title: "Второе",
      description: "Описание",
      price: 2000,
      status: "active",
      category_id: 1,
      city_id: @city.city_id,
      user_id: @user.id,
      created_at: Time.current
    )

    assert_equal [ad2, ad1], Advertisement.recent.to_a
  end


  test "ad_type method should return correct type" do
    @ad.category_id = 1
    assert_equal "transport", @ad.ad_type

    @ad.category_id = 2
    assert_equal "real_estate", @ad.ad_type

    @ad.category_id = 5
    assert_equal "job", @ad.ad_type
  end
end