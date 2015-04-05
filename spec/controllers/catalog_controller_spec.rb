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

  describe "GET /index" do
    it "should return some results" do
      get :index, :q => "bloch", :search_field => "all_fields"

      assigns_response.docs.size.should > 0
      assigns_response.facets.size.should > 0
    end

    it "should include solr weights, assigned on the component/document fields unittitle,unitid,subject,creator,scopcontent,
         bioghist,note,componenet level to the relevancy caculations " do
      get :index, :q => "solr", :search_field => "all_fields", :rows => 20

      assigns_response.should include("weight").as_first_result
      assigns_response.should include("weightref11").in_first(2).results
      assigns_response.should include("weightref12").in_first(3).results
      assigns_response.should include("weightref35").in_first(4).results
      assigns_response.should include("weightref41").in_first(5).results
      assigns_response.should include("weightref36").in_first(9).results
      assigns_response.should include("weightref37").in_first(9).results
      assigns_response.should include("weightref42").in_first(9).results
      assigns_response.should include("weightref38").in_first(9).results
      assigns_response.should include("weightref39").in_first(10).results
      assigns_response.should include("weightref43").in_first(11).results

      
    end

     it "should include solr weights, assigned on the document fields author to the relevancy caculations " do
      get :index, :q => "Accuracy", :search_field => "all_fields"

      assigns_response.should include("weightcollection").as_first_result
      
    end

     it "should include solr weights, assigned on the document fields abstract to the relevancy caculations " do
      get :index, :q => "Simplicity", :search_field => "all_fields"

      assigns_response.should include("weightcollection").as_first_result

    end

     it "should include solr weights, assigned on the document fields aqcinfo to the relevancy caculations " do
      get :index, :q => "Transperancy", :search_field => "all_fields"

      assigns_response.should include("weightcollection").as_first_result

    end

  end

end
