require 'test_helper'

class SolrEadMonkeyPatchTest < ActiveSupport::TestCase
  
  setup :activate_authlogic
  
  test "should initialize indexer" do
    #debugger
  end
  
  test "should update into solr" do
    VCR.use_cassette('update into solr', :match_requests_on => [:body]) do
      ENV['REPO'] = 'archives'
      indexer = SolrEad::Indexer.new(:document=>CustomDocument, :simple => true)
      assert_instance_of(SolrEad::Indexer, indexer)
      Dir.glob(File.join(Rails.root,"test","examples","*.xml")).each do |file|
        indexer.batch_update(file)
      end
      assert_instance_of(Array, indexer.solr_docs)
      indexer.batch_commit
      assert_instance_of(RSolr::Client, indexer.solr)
    end
  end
  
end