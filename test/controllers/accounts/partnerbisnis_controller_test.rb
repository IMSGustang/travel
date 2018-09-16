require 'test_helper'

class Accounts::PartnerbisnisControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get accounts_partnerbisnis_home_url
    assert_response :success
  end

end
