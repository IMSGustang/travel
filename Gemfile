source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.2'
gem 'mysql2'
gem 'sprockets'
# [START gcloud]
gem 'google-cloud'
# [END gcloud]
# [START google_api_client]
gem 'google-api-client'
# [END google_api_client]
gem 'foreman'

gem 'jquery-rails'
#gem 'popper_js', '~> 1.11.1'
gem 'bootstrap', '~> 4.0.0.beta2.1'
gem 'react-rails'

gem 'puma', '~> 3.7'
gem 'sass-rails'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'carrierwave', '~> 1.0'
gem "mini_magick"

gem 'font-awesome-rails'

gem 'mime-types', '~> 3.1'
gem 'netrc', '~> 0.11.0'
gem 'http-accept', '~> 1.7'
gem 'http-cookie', '~> 1.0', '>= 1.0.3'
gem 'rest-client' #, '~> 2.0', '>= 2.0.2'

gem 'httparty'
gem 'oauth2'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'
gem 'listen', '~> 3.1.5'
gem 'pusher'
gem 'kaminari'
#gem 'wdm', '>= 0.1.0'

#gem 'wdm' if Gem.win_platform?

# gem 'redis', '~> 3.0'

# gem 'bcrypt', '~> 3.1.7'

# gem 'capistrano-rails', group: :development

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'capistrano',         require: false
    gem 'capistrano-rvm',     require: false
    gem 'capistrano-rails',   require: false
    gem 'capistrano-bundler', require: false
    gem 'capistrano3-puma',   require: false
    gem 'capistrano-local-precompile', '~> 1.0.0', require: false
end

gem 'tzinfo-data'

gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'
gem 'mailgun-ruby', '~>1.1.6'

# barcode generator
gem 'barby'
gem 'chunky_png'
