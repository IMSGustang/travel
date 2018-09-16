require 'test_helper'

class NaurahControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get naurah_home_url
    assert_response :success
  end

end
