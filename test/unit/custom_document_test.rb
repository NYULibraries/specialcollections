require 'test_helper'

class EadDocumentTest < ActiveSupport::TestCase
  
  test "solr ead index file" do
    VCR.use_cassette('solr_ead index test record', :match_requests_on => [:body]) do
      ENV['FILE'] = "#{Rails.root}/test/dummy/data/archives/adler.xml"
      ENV['DIR'] = nil
      indexer = SolrEad::Indexer.new(:document => EadDocument, :component => EadComponent)
      assert_nothing_raised do
        indexer.update(ENV['FILE'])
      end
      assert_instance_of(SolrEad::Indexer, indexer)
    end
  end
  
  test "solr ead index directory" do
    VCR.use_cassette('solr_ead index test directory', :match_requests_on => [:body]) do
      ENV['DIR'] = "#{Rails.root}/test/dummy/data/archives"
      ENV['FILE'] = nil
      indexer = SolrEad::Indexer.new(:document => EadDocument, :component => EadComponent)
      Dir.glob(File.join(ENV['DIR'],"*")).each do |file|
        assert_nothing_raised do
          indexer.update(file)
        end
      end
      assert_instance_of(SolrEad::Indexer, indexer)        
    end
  end
  
end
