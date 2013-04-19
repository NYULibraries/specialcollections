require 'test_helper'

class SolrEadTest < ActiveSupport::TestCase
  
  setup :activate_authlogic
  
  test "should initialize indexer" do
    ENV['WEBSOLR'] = Settings.solr.url
    ENV['DIR'] = "test/dummy/data/archives"
    indexer = SolrEad::Indexer.new(:document=>CustomDocument)
    assert_instance_of(SolrEad::Indexer, indexer)
    VCR.use_cassette('update eads into solr', :match_requests_on => [:method]) do
     Dir.glob(File.join(Rails.root,"test","dummy","data","archives","*.xml")).each do |file|
       indexer.update(file)
     end
   end
  end
  
  test "should initialize indexer with rails root" do
    indexer = SolrEad::Indexer.new(:document=>CustomDocument)
    assert_instance_of(SolrEad::Indexer, indexer)
  end
  
end