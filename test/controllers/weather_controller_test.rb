require 'test_helper'

class WeatherControllerTest < ActionDispatch::IntegrationTest
  test "should get location" do
    get weather_location_url
    assert_response :success
  end

end
