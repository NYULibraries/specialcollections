require 'spec_helper'

describe CatalogController do
  
  def assigns_response
    @controller.instance_variable_get("@response")
  end
  
  describe ".index" do
    it "should return some results", vcr: { cassette_name: "basic search results" } do
      get :index, :q => "bytsura", :search_field => "all_fields"
      
      assigns_response.docs.size.should > 1
      assigns_response.facets.size.should > 1
    end
  end
  
end