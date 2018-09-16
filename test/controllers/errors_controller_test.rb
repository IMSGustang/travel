require 'test_helper'

class ErrorsControllerTest < ActionDispatch::IntegrationTest
  test "should get 404" do
    get errors_404_url
    assert_response :success
  end

end
