source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.3.5'

# runners
gem 'bootsnap', '>= 1.4.4', require: false
gem 'puma', '~> 5.0'
gem 'rails', '~> 6.1'

# data storage
gem 'redis'
gem 'sqlite3', '~> 1.4'

# data search
gem 'sunspot_rails'

# integrations
gem 'foreman'
gem 'httparty'

# views
gem 'bootstrap', '~> 5.0.1'
gem 'jbuilder', '~> 2.7'
gem 'kaminari'
gem 'react-rails'
gem 'sass-rails', '>= 6'
gem 'slim'
gem 'turbolinks', '~> 5'
gem 'webpacker', '~> 5.0'

# media storage
gem 'carrierwave'
gem 'carrierwave-base64'
gem 'fog-aws'

# self-analysis
gem 'annotate'

# weird patches
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails', '>= 3.1', require: 'dotenv/load'
  gem 'pry-rails'
end

group :development do
  gem 'capistrano', require: false
  gem 'capistrano-passenger', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false
  gem 'listen', '~> 3.3'
  gem 'pronto'
  gem 'pronto-flay', require: false
  gem 'pronto-rubocop', require: false
  gem 'rubocop-rails', require: false
  gem 'rugged', '< 1.7.1' # incompatibility with pronto
  gem 'spring'
  gem 'web-console', '>= 4.1.0'
end

group :test do
  gem 'capybara', '>= 3.26'
  gem 'database_cleaner-active_record'
  gem 'factory_bot_rails'
  gem 'rspec-rails', '~> 5.0.0'
  gem 'selenium-webdriver', '< 3.141.0'
  gem 'shoulda-matchers', '~> 4.0'
  gem 'simplecov', require: false
end
