require 'test_helper'

class TiketControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get tiket_home_url
    assert_response :success
  end

end
