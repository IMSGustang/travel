require 'test_helper'

class PageControllerTest < ActionDispatch::IntegrationTest
  test "should get souvenir" do
    get page_souvenir_url
    assert_response :success
  end

end
