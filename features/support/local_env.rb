require 'coveralls'
Coveralls.wear_merged!('rails')

require 'pry'

# Require support classes in spec/support and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each do |helper|
  require helper
end

# Require and include helper modules
# in feature/support/helpers and its subdirectories.
Dir[Rails.root.join("features/support/helpers/**/*.rb")].each do |helper|
  require helper
  # Only include _helper.rb methods
  if /_helper.rb/ === helper
    helper_name = "FindingaidsFeatures::#{helper.camelize.demodulize.split('.').first}"
    Cucumber::Rails::World.send(:include, helper_name.constantize)
  end
end

# Refresh jetty data before rspec tests run
if Rails.env.test?
  begin
    WebMock.allow_net_connect!
    Findingaids::Ead::Indexer.delete_all
    indexer = Findingaids::Ead::Indexer.new
    indexer.index('spec/fixtures/fales/bloch.xml')
    indexer.index('spec/fixtures/fales/berol.xml')
    indexer.index('spec/fixtures/tamwag/PHOTOS.107-ead.xml')
    indexer.index('spec/fixtures/tamwag/photos_114.xml')
  ensure
    WebMock.disable_net_connect!
  end
end
