require 'test_helper'

class LayoutsControllerTest < ActionDispatch::IntegrationTest
  test "should get beranda" do
    get layouts_beranda_url
    assert_response :success
  end

end
