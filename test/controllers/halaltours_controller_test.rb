require 'test_helper'

class HalaltoursControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get halaltours_home_url
    assert_response :success
  end

end
