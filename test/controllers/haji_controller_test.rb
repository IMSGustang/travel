require 'test_helper'

class HajiControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get haji_home_url
    assert_response :success
  end

end
