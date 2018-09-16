require 'test_helper'

class PaymentControllerTest < ActionDispatch::IntegrationTest
  test "should get metodepembayaran" do
    get payment_metodepembayaran_url
    assert_response :success
  end

end
