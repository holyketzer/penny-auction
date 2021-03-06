source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0'

# Use PostgreSQL as the database for Active Record
gem 'pg'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

gem 'therubyracer'
gem 'less-rails' #Sprockets (what Rails 3.1 uses for its asset pipeline) supports LESS
gem 'twitter-bootstrap-rails'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
gem 'jquery-turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

gem 'ancestry'
gem 'carrierwave'
gem 'mini_magick' # ensure that imagemagick is installed: 'sudo apt-get install imagemagick'
gem 'slim-rails'
gem 'inherited_resources'

# Authentication
gem 'devise'

# Comet (browser push)
gem 'private_pub'
gem 'thin'

# OAuth
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-vkontakte'
gem 'open_uri_redirections'

# Keep secrets in separate config
gem 'figaro'

# Authorization
gem 'cancan'

# Delayed and sceduled jobs
gem 'sidekiq'
gem 'sidetiq'
gem 'sinatra', '>= 1.3.0', require: false

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

group :development do
  gem 'capistrano'
  gem 'rvm-capistrano'
  gem 'net-ssh', '2.7.0'
  gem 'capistrano-sidekiq'
end

group :development, :test do
#  gem 'zeus'
  gem 'rspec-rails'
  gem 'letter_opener'
  gem 'pry-rails'
  gem 'pry-plus'
end

group :test do
  gem 'shoulda-matchers'
  gem 'capybara'
  gem 'webmock'
  gem 'factory_girl_rails'
  gem 'capybara-webkit'
  gem 'database_cleaner'
  gem 'timecop'
end
