require 'test_helper'

class SouvenirControllerTest < ActionDispatch::IntegrationTest
  test "should get daftarproduk" do
    get souvenir_daftarproduk_url
    assert_response :success
  end

end
