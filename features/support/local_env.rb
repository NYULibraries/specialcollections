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

loaded = {}
indexer = EadIndexer::Indexer.new

# Index fixtures where tagged
Before('@bloch') do
  unless loaded[:bloch]
    indexer.index('spec/fixtures/fales/bloch.xml')
    loaded[:bloch] = true
  end
end
Before('@berol') do
  unless loaded[:berol]
    indexer.index('spec/fixtures/fales/berol.xml')
    loaded[:berol] = true
  end
end
Before('@bytsura') do
  unless loaded[:bytsura]
    indexer.index('spec/fixtures/fales/bytsura.xml')
    loaded[:bytsura] = true
  end
end
Before('@heti') do
  unless loaded[:heti]
    indexer.index('spec/fixtures/fales/heti.xml')
    loaded[:heti] = true
  end
end
Before('@bickceem') do
  unless loaded[:bickceem]
    indexer.index('spec/fixtures/fales/bickceem.xml')
    loaded[:bickceem] = true
  end
end
Before('@bartlett') do
  unless loaded[:bartlett]
    indexer.index('spec/fixtures/fales/bartlett.xml')
    loaded[:bartlett] = true
  end
end
Before('@oconor') do
  unless loaded[:oconor]
    indexer.index('spec/fixtures/fales/oconor.xml')
    loaded[:oconor] = true
  end
end
Before('@washsquarephoto') do
  unless loaded[:washsquarephoto]
    indexer.index('spec/fixtures/fales/washsquarephoto.xml')
    loaded[:washsquarephoto] = true
  end
end
Before('@kopit_revised') do
  unless loaded[:kopit_revised]
    indexer.index('spec/fixtures/fales/kopit_revised.xml')
    loaded[:kopit_revised] = true
  end
end
Before('@photos_107') do
  indexer.index('spec/fixtures/tamwag/PHOTOS.107-ead.xml')
end
Before('@photos_114') do
  indexer.index('spec/fixtures/tamwag/photos_114.xml')
end
Before('@OH_002') do
  unless loaded[:OH_002]
    indexer.index('spec/fixtures/tamwag/OH.002-ead.xml')
    loaded[:OH_002] = true
  end
end
