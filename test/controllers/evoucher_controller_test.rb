require 'test_helper'

class EvoucherControllerTest < ActionDispatch::IntegrationTest
  test "should get pulsa" do
    get evoucher_home_url
    assert_response :success
  end

end
