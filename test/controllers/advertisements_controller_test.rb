require "test_helper"

class AdvertisementsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @city = City.create!(
      city_id: 1,
      name: "Москва",
      region: "Московская область",
      country: "Россия"
    )

    @user = User.create!(
      username: "testuser",
      email: "test@example.com",
      password: "password123",
      password_confirmation: "password123",
      city_id: @city.city_id
    )

    log_in_as(@user)

    @advertisement = Advertisement.create!(
      ad_id: 1,
      title: "Тестовое объявление",
      description: "Описание",
      price: 1000,
      status: "active",
      category_id: 1,
      city_id: @city.city_id,
      user_id: @user.id
    )
  end

  test "should get index" do
    get advertisements_path
    assert_response :success
    assert_select "h1", /БАРАХЛА.НЕТ!/
  end

  test "should get new" do
    get new_advertisement_path
    assert_response :success
  end

  test "should create advertisement with real estate category" do
    assert_difference('Advertisement.count', 1) do
      assert_difference('RealEstate.count', 1) do
        post advertisements_path, params: {
          advertisement: {
            title: "Продам квартиру",
            description: "Хорошая квартира",
            price: 5000000,
            status: "active",
            category_id: 2,  # Real Estate
            city_id: @city.city_id,
            # Параметры для недвижимости
            property_type: "apartment",
            total_area: 50.5,
            living_area: 35.0,
            floor: 5,
            total_floors: 9,
            rooms_count: 3
          }
        }
      end
    end

    assert_redirected_to my_advertisements_path
    assert_equal "Объявление успешно создано!", flash[:notice]
  end


  test "should not create invalid advertisement" do
    assert_no_difference('Advertisement.count') do
      post advertisements_path, params: {
        advertisement: {
          title: "",
          description: "",
          price: -100,
          status: "active",
          category_id: 1,
          city_id: @city.city_id
        }
      }
    end

    assert_response :unprocessable_entity
  end

  test "should get edit" do
    get edit_advertisement_path(@advertisement)
    assert_response :success
  end

  test "should update advertisement" do
    patch advertisement_path(@advertisement), params: {
      advertisement: {
        title: "Обновленное название",
        price: 2000
      }
    }

    @advertisement.reload
    assert_equal "Обновленное название", @advertisement.title
    assert_equal 2000, @advertisement.price
    assert_redirected_to my_advertisements_path
    assert_equal "Объявление обновлено!", flash[:notice]
  end

  test "should destroy advertisement" do
    assert_difference('Advertisement.count', -1) do
      delete advertisement_path(@advertisement)
    end

    assert_redirected_to advertisements_path
    assert_equal "Объявление удалено!", flash[:notice]
  end

  test "should get my advertisements" do
    get my_advertisements_path
    assert_response :success
    assert_select "h1", /Мои объявления/
  end

  test "should filter by category" do
    get advertisements_path, params: { category_id: 1 }
    assert_response :success
  end

  test "should filter by price range" do
    get advertisements_path, params: { min_price: 500, max_price: 1500 }
    assert_response :success
  end

  test "should require login for new" do
    delete logout_path
    get new_advertisement_path
    assert_redirected_to login_path
    assert_equal "Пожалуйста, войдите в систему", flash[:alert]
  end
end# frozen_string_literal: true

