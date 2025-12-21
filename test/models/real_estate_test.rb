require "test_helper"

class RealEstateTest < ActiveSupport::TestCase
  def setup
    @user = create_test_user
    @city = create_test_city
    @ad = Advertisement.create!(
      ad_id: 2,
      title: "Test Apartment",
      description: "Test apartment",
      price: 50000,
      status: "active",
      category_id: 2,
      city_id: @city.city_id,
      user_id: @user.id
    )

    @real_estate = RealEstate.new(
      advertisement: @ad,
      property_type: "apartment",
      total_area: 50.5
    )
  end

  test "should be valid" do
    assert @real_estate.valid?
  end

  test "total_area should be positive" do
    @real_estate.total_area = 0
    assert_not @real_estate.valid?

    @real_estate.total_area = -10
    assert_not @real_estate.valid?
  end
end