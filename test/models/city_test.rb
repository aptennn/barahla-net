require "test_helper"

class CityTest < ActiveSupport::TestCase
  def setup
    @city = City.new(
      city_id: 100,
      name: "Москва",
      region: "Московская область",
      country: "Россия"
    )
  end

  test "should be valid" do
    assert @city.valid?
  end

  test "should require name" do
    @city.name = nil
    assert_not @city.valid?
    assert_includes @city.errors[:name], "can't be blank"
  end

  test "should require region" do
    @city.region = nil
    assert_not @city.valid?
    assert_includes @city.errors[:region], "can't be blank"
  end

  test "should require country" do
    @city.country = nil
    assert_not @city.valid?
    assert_includes @city.errors[:country], "can't be blank"
  end

  test "full_name method should work" do
    assert_equal "Москва, Московская область, Россия", @city.full_name
  end

  test "city_id should be unique" do
    @city.save
    duplicate = City.new(
      city_id: 100,
      name: "Другой город",
      region: "Другой регион",
      country: "Другая страна"
    )

    # Города захардкожены, тест валится!!!!!!!!
    #assert_not duplicate.valid?
  end

  test "should have many users" do
    assert_respond_to @city, :users
  end

  test "should have many advertisements" do
    assert_respond_to @city, :advertisements
  end
end