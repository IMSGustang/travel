require 'test_helper'

class Page::SouvenirControllerTest < ActionDispatch::IntegrationTest
  test "should get pulsa" do
    get page_souvenir_home_url
    assert_response :success
  end

end
