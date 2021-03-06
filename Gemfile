source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.1'
# Use postgresql as the database for Active Record
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
#gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use slim templates
gem 'slim-rails'

# Add some bootstrap styling
gem 'bootstrap-sass', '3.2.0.0'

# Use devise for managing users
gem 'devise'

# CarrierWave for uploading files
gem 'carrierwave'

# Send files via ajax forms
gem 'remotipart'

# For dynamic generation of forms
gem 'cocoon'

# Using ryanb solution for comet: private_pub use faye
gem 'private_pub'
gem 'thin'

# For cool responders //rails g responders:install
gem 'responders'

# For facebook, twitter, vk authentication etc
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-twitter'

gem 'email_validator'

# For authorization
gem 'cancancan'

# For API
gem 'doorkeeper'
gem 'active_model_serializers'
gem 'oj'
gem 'oj_mimic_json'

# For background jobs
gem 'sidekiq'
gem 'sinatra', '>=1.3.0', require: nil
gem 'whenever'

# For fulltext search
gem 'mysql2'
gem 'thinking-sphinx'

# For ENV vars, let it be easy
gem 'dotenv'
gem 'dotenv-deployment', require: 'dotenv/deployment'

group :development do
  # For easy project deploy
  gem 'capistrano', '~> 3.4.0', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-sidekiq', require: false
  gem 'capistrano3-unicorn', require: false

  # For watching letters in browser
  gem 'letter_opener'

  # Quiet assets
  gem 'quiet_assets'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'pry-rails'

  gem 'rubocop', require: false
end

group :test do
  gem 'shoulda-matchers'
  gem 'capybara'
  gem 'launchy'
  #gem 'selenium-webdriver'
  gem 'capybara-webkit'
  gem 'database_cleaner'
  gem 'email_spec'
  gem 'capybara-email'
  gem 'json_spec'
end
