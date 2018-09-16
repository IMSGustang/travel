# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

ENV['RAILS_ENV'] = 'development'
# ppob
ENV['PPOB_API_URL'] = 'http://apiv3.abutours.com/v1/ppob/'
# pusher
ENV['PUSH_APP_ID'] = '412035'
ENV['PUSH_APP_KEY'] = 'dc6bc7c0c6aeecc1d4f8'
ENV['PUSH_APP_SECRET'] = '6d48a213a83854d59ea7'
ENV['PUSH_APP_CLUSTER'] = 'ap1'
