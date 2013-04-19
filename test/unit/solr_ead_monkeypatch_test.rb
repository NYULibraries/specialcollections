require 'test_helper'

class SolrEadMonkeyPatchTest < ActiveSupport::TestCase
  
  setup :activate_authlogic
  
  test "should initialize indexer" do
    indexer = SolrEad::Indexer.new(:document=>CustomDocument, :simple => true)
    assert_instance_of(SolrEad::Indexer, indexer)
  end
  
end