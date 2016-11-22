source 'https://rubygems.org'

gem 'rails', '~> 4.2.7.1'

# Use MySQL for the database
gem 'mysql2', '~> 0.3.16'

# Use SCSS for stylesheets
# Locked in at beta1 release because major release doesn't play nice with compass-rails yet
gem 'sass-rails', '5.0.0.beta1'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.1.0'

# Use jQuery as the JavaScript library
gem 'jquery-rails', '~> 3.1.0'

# Use jQuery UI as well
gem 'jquery-ui-rails', '~> 5.0.2'

# Use font-awesome
gem 'font-awesome-rails', '~> 4.2.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '~> 2.7.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', '~> 0.12.0'

# Use the Compass CSS framework for sprites, etc.
gem 'compass-rails', '~> 2.0.0'

gem 'jbuilder', '~> 2.6.0'

# Use the NYU Libraries assets gem for shared NYU Libraries assets
gem 'nyulibraries_stylesheets', git: 'https://github.com/NYULibraries/nyulibraries_stylesheets'
gem 'nyulibraries_templates', git: 'https://github.com/NYULibraries/nyulibraries_templates'
gem 'nyulibraries_institutions', git: 'https://github.com/NYULibraries/nyulibraries_institutions'
gem 'nyulibraries_javascripts', git: 'https://github.com/NYULibraries/nyulibraries_javascripts'
gem 'nyulibraries_errors', git: 'https://github.com/NYULibraries/nyulibraries_errors', tag: 'v1.0.0'

# Deploy the application with Formaggio deploy recipes
gem 'formaggio', git: 'https://github.com/NYULibraries/formaggio', tag: 'v1.4.2'

# Use Blacklight for searching Solr
gem 'blacklight', '~> 6.6'
# gem 'blacklight', path: '/apps/blacklight'

# Use the Blacklight Advanced Search
gem 'blacklight_advanced_search'

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
# EAD indexing
gem 'ead_indexer', git: 'https://github.com/NYULibraries/ead_indexer'

# ISO 639 Language mapper
gem 'iso-639', '~> 0.2.5'

# Transition gems
gem 'exlibris-aleph', '~> 2.0.4'
gem 'omniauth-nyulibraries', git: 'https://github.com/NYULibraries/omniauth-nyulibraries',  tag: 'v2.0.0'
gem 'devise', '~> 3.5.4'
# /Transition gems

# Faraday for http calls
gem 'faraday', '~> 0.9.1'

group :development do
  gem 'better_errors', '~> 2.0.0'
  gem 'binding_of_caller', '~> 0.7.2'
  gem 'guard', '~> 2.14.0'
  gem 'guard-rspec', '~> 4.3.1'
  gem 'guard-cucumber', '~> 2.1.2'
end

group :test do
  # Use Cucumber for integration testing
  gem 'cucumber-rails', '~> 1.4.5', require: false
  # Use VCR for testing with deterministic HTTP interactions
  gem 'vcr', '~> 3.0.3'
  gem 'webmock', '~> 2.1'
  # Use Selenium as the web driver for Cucumber
  gem 'selenium-webdriver', '~> 3.0'
  # Use DatabaseCleaner for clearing the test database
  gem 'database_cleaner', '~> 1.5.3'
  # Use factory girl for creating models
  gem 'factory_girl_rails', '~> 4.7.0'
  # Rspec as the test framework
  gem 'rspec-rails', '~> 3'
  gem 'rspec-its', '~> 1.2.0'
  gem 'rspec-collection_matchers', '~> 1.1.2'
  # Phantomjs for headless browser testing
  gem 'poltergeist', '~> 1.11.0'
  gem 'phantomjs', '~> 2.1.1'
  # Use SimpleCov for generating local coverage reports
  gem 'simplecov', '~> 0.9.2', require: false
  gem 'simplecov-rcov', '~> 0.2.3', require: false
  # Use Coveralls to publish coverage on the open web
  gem 'coveralls', '~> 0.7.0', require: false
  gem 'term-ansicolor', '>= 1.3.2'
end

group :development, :test do
  gem 'solr_wrapper', '>= 0.3'
  # Use Jetty for test and development Solr
  gem 'jettywrapper', '~> 1.7'
  gem 'pry'
end
