source 'https://rubygems.org'

# Tell Heroku that this is a ruby 2 application
ruby '2.0.0'

group :development, :test do
  # Debugger
  gem 'pry'
end

group :development do
  # Better Errors replaces the standard Rails error page with a much better and more useful error page
  gem 'better_errors'

  # Enable the REPL and local/instance variable inspection in Better Errors
  gem 'binding_of_caller'

  # Bullet will watch your queries while you develop your application and notify you when you should add eager loading (N+1 queries), when you’re using eager loading that isn’t necessary and when you should use counter cache
  gem 'bullet'

  # Use CoffeeScript for .js.coffee assets and views
  gem 'coffee-rails', '~> 4.0.0'

  # Share localhost web servers to the rest of the world
  gem 'localtunnel'

  # Turn off the Rails asset pipeline log
  gem 'quiet_assets'

  # Code metrics
  gem 'rails_best_practices'
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  # gem 'sdoc', require: false
end

group :test do
  # Capybara simulates how a real user would interact with a web application
  # gem 'capybara'

  # Fixture replacement
  gem 'fabrication'

  # Dummy data
  gem 'ffaker'

  # Make rspec result look pretty in command line
  gem 'nyan-cat-formatter'

  # Unit test
  gem 'rspec-rails'

  # Make rspec faster
  gem 'spork-rails', git: 'https://github.com/A-gen/spork-rails.git'
end

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 1.0.1'

# Use jquery as the JavaScript library
gem 'jquery-rails'

# App monitoring
gem 'newrelic_rpm'

# Convert empty string to nil before save
# gem 'nilify_blanks'

# Use postgresql as the database for Active Record
gem 'pg'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# SOLR powered full-text search engine
# gem 'sunspot'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Use Twillio to receive text messages
gem 'twilio-ruby'

# Use Twitter Bootstrap
gem 'twitter-bootstrap-rails'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use underscore.js
gem 'underscore-rails'
