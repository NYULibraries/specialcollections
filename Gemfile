source 'https://rubygems.org'

gem 'rails', '~> 3.2.17'
gem 'mysql2', '~> 0.3.14'
gem 'json', '~> 1.8.1'
gem 'coffee-rails', '~> 3.2.0'
gem 'nyulibraries-deploy', :git => 'git://github.com/NYULibraries/nyulibraries-deploy.git', :tag => 'v4.0.0'
gem 'nyulibraries-assets', :git => 'git://github.com/NYULibraries/nyulibraries-assets.git', :tag => 'v2.0.1'
gem 'authpds-nyu', :git => 'git://github.com/NYULibraries/authpds-nyu.git', :tag => 'v1.1.3'
gem 'rails_config', '~> 0.3.3'
gem 'jquery-rails', '~> 3.0.4'
gem 'jquery-ui-rails', '~> 4.1.1'
#gem 'blacklight', :path => '/apps/blacklight'
gem 'blacklight', '~> 4.6.2'
gem 'blacklight-sitemap', :github => 'awead/blacklight-sitemap'
gem 'blacklight_advanced_search'
gem 'sorted', '~> 1.0.0'
gem 'dalli', '~> 2.7.0'
#gem 'newrelic_rpm'
gem 'comma', '~> 3.2.0'
gem 'mustache', '0.99.4'
gem 'mustache-rails', '~> 0.2.3', :require => 'mustache/railtie'
gem 'unicode', '~> 0.4.4', :platforms => [:mri_18, :mri_19]
gem 'solr_ead', '~> 0.7.1'
gem 'sanitize', '~> 2.1.0'
#gem 'solr_ead', :path => "/apps/solr_ead"
gem 'rspec-rails', :group => [:test, :development]

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'compass-rails', '~> 1.1.3'
  gem 'compass-susy-plugin', '~> 0.9.0'
  gem 'therubyracer', '~> 0.12.0', :platforms => :ruby
  gem 'uglifier', '~> 2.4.0'
  gem 'yui-compressor', '~> 0.12.0'
end

group :test do
  gem 'coveralls', '~> 0.7.0', :require => false
  gem 'vcr', '~> 2.8.0'
  gem 'webmock', '~> 1.16.1'
  gem 'simplecov', :require => false
  gem 'simplecov-rcov', :require => false
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'guard-rspec'
end

group :development do 
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'sunspot_solr'
end

gem 'debugger', :groups => [:development, :test]
