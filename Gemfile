source 'https://rubygems.org'

gem 'rails', '~> 5.0.0'
gem 'mail', '2.6.6.rc1'
gem 'rake'

# Use MySQL for the database
gem 'mysql2', '~> 0.4.5'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.2.0'

# Use jQuery as the JavaScript library
gem 'jquery-rails', '~> 4.3.0'

# Use jQuery UI as well
gem 'jquery-ui-rails', '~> 6.0.1'

# Use font-awesome
gem 'font-awesome-rails', '~> 4.7.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '~> 3.1.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
group :no_docker do
  gem 'therubyracer', '~> 0.12.0'
end

# Use the Compass CSS framework for sprites, etc.
gem 'compass-rails', '~> 3.0.0'

gem 'jbuilder', '~> 2.6.0'

# Use the NYU Libraries assets gem for shared NYU Libraries assets
gem 'nyulibraries_stylesheets', github: 'NYULibraries/nyulibraries_stylesheets', tag: 'v1.1.2'
gem 'nyulibraries_templates', github: 'NYULibraries/nyulibraries_templates', tag: 'v1.2.3'
gem 'nyulibraries_institutions', github: 'NYULibraries/nyulibraries_institutions', tag: 'v1.0.3'
gem 'nyulibraries_javascripts', github: 'NYULibraries/nyulibraries_javascripts', tag: 'v1.0.0'
gem 'nyulibraries_errors', github: 'NYULibraries/nyulibraries_errors', tag: 'v1.1.1'

# Use Blacklight for searching Solr
gem 'blacklight', '~> 6.15.0'

# Use the Blacklight Advanced Search
gem 'blacklight_advanced_search', '~> 6.4.0'

# Use sorted for sorting columns
gem 'sorted', '~> 2.0'

# Use Dalli for memcached
gem 'dalli', '~> 2.7.0'

# Comma to download CSV
gem 'comma', '~> 4.2.0'

# SolrEad to index EAD into Solr
gem 'solr_ead', '~> 0.7.4'
# Required update for vulnurability
gem 'sanitize', '~> 4.6.3'
# EAD indexing
gem 'ead_indexer', github: 'NYULibraries/ead_indexer', tag: 'v0.0.2'

# ISO 639 Language mapper
gem 'iso-639', '~> 0.2.5'

# Transition gems
gem 'exlibris-aleph', '~> 2.0.4'
gem 'omniauth-nyulibraries', github: 'NYULibraries/omniauth-nyulibraries',  tag: 'v2.0.0'
gem 'devise', '~> 4.3.0'
# /Transition gems

# Faraday for http calls
gem 'faraday', '~> 0.9.0'

gem "sentry-raven", '~> 2'

gem 'unicorn', '~> 5.3.0'

gem 'formaggio', github: 'NYULibraries/formaggio', tag: 'v1.8.0'

group :development do
  gem 'better_errors', '~> 2.1.0'
  gem 'binding_of_caller', '~> 0.7.2'
  gem 'guard', '~> 2.14.0'
  gem 'guard-rspec', '~> 4.7'
  gem 'guard-cucumber', '~> 2.1.2'
end

group :test do
  # Use Cucumber for integration testing
  gem 'cucumber-rails', '~> 1.4.5', require: false
  # Use Selenium as the web driver for Cucumber
  gem 'selenium-webdriver', '~> 3.14'
  # Use DatabaseCleaner for clearing the test database
  gem 'database_cleaner', '~> 1.5.3'
  # Use factory girl for creating models
  gem 'factory_bot_rails', '~> 4.8.0'
  # Rspec as the test framework
  gem 'rspec-rails', '~> 3'
  gem 'rspec-its', '~> 1.2.0'
  gem 'rspec-collection_matchers', '~> 1.1.2'
  # controller testing for rails 5+
  gem 'rails-controller-testing'
  # Phantomjs for headless browser testing
  gem 'poltergeist', '~> 1.14.0'
  gem 'phantomjs', '~> 2.1.1'
  # Use SimpleCov for generating local coverage reports
  gem 'simplecov', '~> 0.14.1', require: false
  gem 'simplecov-rcov', '~> 0.2.3', require: false
  # Use Coveralls to publish coverage on the open web
  gem 'coveralls', '~> 0.8', require: false
  gem 'term-ansicolor', '>= 1.3.2'
end

group :development, :test do
  gem 'solr_wrapper', '~> 1'
  gem 'pry', '~> 0'
end
