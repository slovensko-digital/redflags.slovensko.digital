source 'https://rubygems.org'

ruby file: '.ruby-version'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 8.1.4'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.6'
# Use Puma as the app server
gem 'puma', '>= 6.0'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# The asset pipeline with Sass compiled by Dart Sass
gem 'sprockets-rails'
gem 'dartsass-sprockets'
gem 'bootstrap', '~> 4.6.2'
# Use Terser as compressor for JavaScript assets
gem 'terser'
gem 'jquery-rails'
gem 'font-awesome-rails'
gem 'kaminari'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'

gem 'discourse_api'
# Jobs and their schedule run in the web server process
gem 'good_job', '~> 4.24'

gem 'rollbar'
gem 'oj'

# Use Google API gems
gem 'google-apis-docs_v1'
gem 'google-apis-drive_v3'
gem 'google-apis-sheets_v4'

gem 'brevo', '~> 4.0'

# No longer a default gem since Ruby 3.5
gem 'ostruct'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[windows jruby]

group :development, :test do
  gem 'dotenv-rails'
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'simplecov', require: false
  gem 'vcr'
  gem 'webmock'
  gem 'capybara'

  gem 'foreman'
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri windows], require: 'debug/prelude'
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'web-console'
  gem 'annotaterb'
end
