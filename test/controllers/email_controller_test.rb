require 'test_helper'

class EmailControllerTest < ActionDispatch::IntegrationTest
  test "should get verifikasi" do
    get email_verifikasi_url
    assert_response :success
  end

end
