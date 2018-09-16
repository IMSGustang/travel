require 'test_helper'

class PartnerbisnisControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get partnerbisnis_home_url
    assert_response :success
  end

end
