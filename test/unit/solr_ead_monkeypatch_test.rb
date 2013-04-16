require 'test_helper'

class SolrEadMonkeyPatchTest < ActiveSupport::TestCase
  
  setup :activate_authlogic
  
  test "should initialize indexer" do
    #debugger
  end
  
  test "should update into solr" do
    VCR.use_cassette('update into solr', :record => :once, :match_requests_on => [:body]) do
      ENV['REPO'] = 'archives'
      indexer = SolrEad::Indexer.new(:document=>CustomDocument, :simple => true)
      assert_instance_of(SolrEad::Indexer, indexer)
      indexer.update_without_commit(File.join(Rails.root, "test", "examples", "adler.xml"))
      assert_instance_of(RSolr::Client, indexer.solr)
    end
  end
  
end