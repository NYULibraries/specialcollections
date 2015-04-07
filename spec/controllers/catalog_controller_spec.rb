require 'spec_helper'
require 'rspec-solr'

describe CatalogController do

  before(:all) do
    Findingaids::Ead::Indexer.delete_all
    indexer = Findingaids::Ead::Indexer.new
    indexer.index(Rails.root.join('spec','fixtures','fales','bloch.xml').to_s)
    indexer.index(Rails.root.join('spec','fixtures','fales','EAD_example_weights.xml').to_s)
    indexer.index(Rails.root.join('spec','fixtures','fales','EAD_example_weights_collection.xml').to_s)
  end

  def assigns_response
    RSpecSolr::SolrResponseHash.new(@controller.instance_variable_get("@response"))
  end

  def get_doc_ids solr_docs
    @doc_ids=[]
    solr_docs.each do |doc|
      @doc_ids << doc[:id]
    end
    @doc_ids
  end

  describe "GET /index" do
    it "should return some results" do
      get :index, :q => "bloch", :search_field => "all_fields"

      assigns_response.docs.size.should > 0
      assigns_response.facets.size.should > 0
    end

    it "should include solr weights, assigned on the component/document fields unittitle,unitid,subject,creator,scopcontent,
         bioghist,note,componenet level to the relevancy calculations " do
      get :index, :q => "solr", :search_field => "all_fields", :rows => 20

      doc_ids=get_doc_ids(assigns_response.docs)

      doc_ids.should include("weight").as_first_result
      doc_ids.should include("weightref11").in_first(2).results
      doc_ids.should include("weightref12").in_first(3).results
      doc_ids.should include("weightref35").in_first(4).results
      doc_ids.should include("weightref41").in_first(5).results
      doc_ids.should include("weightref36").in_first(9).results
      doc_ids.should include("weightref37").in_first(9).results
      doc_ids.should include("weightref42").in_first(9).results
      doc_ids.should include("weightref38").in_first(9).results
      doc_ids.should include("weightref39").in_first(10).results
      doc_ids.should include("weightref43").in_first(11).results
    end

     it "should include solr weights, assigned on the document fields author to the relevancy calculations " do
      get :index, :q => "Accuracy", :search_field => "all_fields"
       
      get_doc_ids(assigns_response.docs).should include("weightcollection").as_first_result
    end

     it "should include solr weights, assigned on the document fields abstract to the relevancy calculations " do
      get :index, :q => "Simplicity", :search_field => "all_fields"

      get_doc_ids(assigns_response.docs).should include("weightcollection").as_first_result
    end

     it "should include solr weights, assigned on the document fields aqcinfo to the relevancy calculations " do
      get :index, :q => "Transperancy", :search_field => "all_fields"

      get_doc_ids(assigns_response.docs).should include("weightcollection").as_first_result
    end
  end
end
