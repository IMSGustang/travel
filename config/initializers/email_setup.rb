ActionMailer::Base.delivery_method = :mailgun
Mailgun.configure do |config|
  config.api_key = 'key-eca207fc4eeccac83e1bab7b0ee6bf12'
end
