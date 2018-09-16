require 'test_helper'

class AdministratorControllerTest < ActionDispatch::IntegrationTest
  test "should get dashboard" do
    get administrator_dashboard_url
    assert_response :success
  end

end
