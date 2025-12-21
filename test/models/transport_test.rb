require "test_helper"

class TransportTest < ActiveSupport::TestCase
  def setup
    @user = create_test_user
    @city = create_test_city
    @ad = Advertisement.create!(
      ad_id: 1,
      title: "Test Car",
      description: "Test car",
      price: 10000,
      status: "active",
      category_id: 1,
      city_id: @city.city_id,
      user_id: @user.id
    )

    @transport = Transport.new(
      advertisement: @ad,
      brand: "Toyota",
      model: "Camry",
      year: 2020
    )
  end

  test "should be valid" do
    assert @transport.valid?
  end

  test "should require brand and model" do
    @transport.brand = ""
    assert_not @transport.valid?

    @transport.model = ""
    assert_not @transport.valid?
  end


end# frozen_string_literal: true

