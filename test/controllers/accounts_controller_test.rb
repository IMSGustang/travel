require 'test_helper'

class AccountsControllerTest < ActionDispatch::IntegrationTest
  test "should get paykonfirmasi" do
    get accounts_paykonfirmasi_url
    assert_response :success
  end

end
