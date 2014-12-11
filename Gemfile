source 'https://rubygems.org'

gem 'rails', '~> 4.1.0'

# Use MySQL for the database
gem 'mysql2', '~> 0.3.16'

# Use SCSS for stylesheets
gem 'sass-rails',   '>= 5.0.0.beta1'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.1.0'

# Use jQuery as the JavaScript library
gem 'jquery-rails', '~> 3.1.0'

# Use jQuery UI as well
gem 'jquery-ui-rails', '~> 5.0.2'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '~> 2.5.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', '~> 0.12.0'

# Use the Compass CSS framework for sprites, etc.
gem 'compass-rails', '~> 2.0.0'

# Use mustache for templating
# Fix to 0.99.4 cuz 0.99.5 broke my shit.
gem 'mustache', '0.99.4'
gem 'mustache-rails', github: 'josh/mustache-rails', require: 'mustache/railtie', tag: 'v0.2.3'

# Use the NYU Libraries assets gem for shared NYU Libraries assets
gem 'nyulibraries-assets', github: 'NYULibraries/nyulibraries-assets', tag: 'v4.1.2'

# Deploy the application with Formaggio deploy recipes
gem 'formaggio', github: 'NYULibraries/formaggio', tag: 'v1.3.0'

# Use Blacklight for searching Solr
gem 'blacklight', '~> 5.7.2'

gem 'unicode', '~> 0.4.4', :platforms => [:mri_18, :mri_19]

# Use sorted for sorting columns
gem 'sorted', '~> 1.0.0'

# Use Dalli for memcached
gem 'dalli', '~> 2.7.0'

# New Recic for tracking performance
gem 'newrelic_rpm', '~> 3.6'

# Comma to download CSV
gem 'comma', '~> 3.2.0'

# SolrEad to index EAD into Solr
gem 'solr_ead', '~> 0.7.2'

# HTML sanitizer
gem 'sanitize', '~> 2.1.0'

# Transition gems
gem 'exlibris-aleph', github: 'barnabyalter/exlibris-aleph'
# Use AuthPDS for authentication and authorization
gem 'authpds', github: 'barnabyalter/authpds'
gem 'authpds-nyu', github: 'barnabyalter/authpds-nyu'
# /Transition gems

group :development do
  gem 'better_errors', '~> 2.0.0'
  gem 'binding_of_caller', '~> 0.7.2'
end

group :test do
  gem 'cucumber-rails', require: false
  gem 'simplecov', require: false
  gem 'simplecov-rcov', require: false
  gem 'coveralls', '~> 0.7.0', require: false
  gem 'vcr', '~> 2.9.3'
  gem 'webmock', '~> 1.20.0'
  gem 'selenium-webdriver', '~> 2.43.0'
  gem 'pickle', '~> 0.4.11'
  gem 'database_cleaner', '~> 1.3.0'
  gem 'factory_girl_rails', '~> 4.5.0'
  gem 'rspec-rails', '~> 2.14.2'
end

gem 'pry', group: [:test, :development]
gem 'jettywrapper', '~> 1.7', group: [:test, :development]
