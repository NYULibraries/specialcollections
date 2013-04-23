source 'https://rubygems.org'

gem 'rails', '~> 3.2.13'

gem 'mysql2'

gem 'json', "~> 1.7.7"

gem 'coffee-rails', '~> 3.2.0'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'compass-rails', '~> 1.0.0'
  gem 'compass-susy-plugin', '~> 0.9.0'
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', "~> 0.11.4", :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
  gem 'yui-compressor', "~> 0.9.6"
end

group :development, :test do
  gem 'debugger'
  gem 'progress_bar'
  gem 'sunspot_solr', "~> 2.0.0"
end

group :test do
  gem 'coveralls', "~> 0.6.2", :require => false
  gem "vcr", "~> 2.4.0"
  gem "webmock", "~> 1.11.0"
end

group :development do 
  gem "better_errors"
  gem "binding_of_caller"
end

group :test do
  #Testing coverage
  gem 'simplecov', :require => false
  gem 'simplecov-rcov', :require => false
  #gem 'ruby-prof' #For Benchmarking
end

# Deploy with Capistrano
gem 'rvm-capistrano', "~> 1.3.0"
gem "rake_nyu", :git => "git://github.com/NYULibraries/rake_nyu.git"
gem "rails_config", "~> 0.3.2"

gem 'sunspot_rails', "~> 2.0.0"
gem 'acts-as-taggable-on', '~> 2.4.0'

gem 'authpds-nyu', "~> 0.2.12"
gem 'jquery-rails', "~> 2.2.1"

gem 'blacklight', '~> 4.2.0'#:path => "/apps/blacklight"
gem 'sorted', '~> 0.4.3'

# For memcached
gem 'dalli', "~> 2.6.2"

#gem 'newrelic_rpm', "~> 3.6.0"

gem "comma", "~> 3.0.4"

gem 'nyulibraries_assets', :git => 'git://github.com/NYULibraries/nyulibraries_assets.git', :tag => "v1.0.8-no-bootstrap-sass-dep"
#gem  'nyulibraries_assets', :path => '/apps/nyulibraries_assets'
gem 'mustache-rails', "~> 0.2.3", :require => 'mustache/railtie'

gem "unicode", "~> 0.4.4", :platforms => [:mri_18, :mri_19]
gem "solr_ead", "~> 0.4.4"
