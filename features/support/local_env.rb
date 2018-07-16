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

Before do
  EadIndexer::Indexer.delete_all
  @indexer = EadIndexer::Indexer.new
end

# Index fixtures where tagged
Before('@bloch') do
  @indexer.index('spec/fixtures/fales/bloch.xml')
end
Before('@berol') do
  @indexer.index('spec/fixtures/fales/berol.xml')
end
Before('@bytsura') do
  @indexer.index('spec/fixtures/fales/bytsura.xml')
end
Before('@heti') do
  @indexer.index('spec/fixtures/fales/heti.xml')
end
Before('@bickceem') do
  @indexer.index('spec/fixtures/fales/bickceem.xml')
end
Before('@bartlett') do
  @indexer.index('spec/fixtures/fales/bartlett.xml')
end
Before('@oconor') do
  @indexer.index('spec/fixtures/fales/oconor.xml')
end
Before('@washsquarephoto') do
  @indexer.index('spec/fixtures/fales/washsquarephoto.xml')
end
Before('@kopit_revised') do
  @indexer.index('spec/fixtures/fales/kopit_revised.xml')
end
Before('@photos_107') do
  @indexer.index('spec/fixtures/tamwag/PHOTOS.107-ead.xml')
end
Before('@photos_114') do
  @indexer.index('spec/fixtures/tamwag/photos_114.xml')
end
Before('@OH_002') do
  @indexer.index('spec/fixtures/tamwag/OH.002-ead.xml')
end
