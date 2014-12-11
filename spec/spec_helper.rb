require 'simplecov'
require 'simplecov-rcov'
require 'coveralls'

SimpleCov.merge_timeout 3600
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::RcovFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start

ENV["RAILS_ENV"] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'vcr'
require 'capybara/rspec'
require 'database_cleaner'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Refresh jetty data before rspec tests run
if Rails.env.test?
  begin
    WebMock.allow_net_connect!
    indexer = SolrEad::Indexer.new(:document=>Findingaids::Ead::Document, :component=>Findingaids::Ead::Component)
    indexer.update(Rails.root.join('spec','fixtures','fales','bytsura.xml'))
    indexer.update(Rails.root.join('spec','fixtures','tamwag','photos_114.xml'))
  ensure
    WebMock.disable_net_connect!
  end
end

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.include FactoryGirl::Syntax::Methods

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"
end

VCR.configure do |c|
  c.default_cassette_options = { allow_playback_repeats: true, record: :new_episodes }
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.ignore_localhost = true
  c.configure_rspec_metadata!
  c.hook_into :webmock
  c.filter_sensitive_data("http://localhost:8981/solr") { ENV['SOLR_URL'] }
end

def ead_fixture file
  File.new(File.join(File.dirname(__FILE__), 'fixtures', 'ead', file))
end
