require 'test_helper'

class AccountControllerTest < ActionDispatch::IntegrationTest
  test "should get dashboard" do
    get account_dashboard_url
    assert_response :success
  end

end
