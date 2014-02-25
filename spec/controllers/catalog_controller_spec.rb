require 'spec_helper'

describe CatalogController do
  describe "GET index" do
    it "should render dropdown search fields", vcr: { cassette_name: "match dropdown search fields" } do
      get :index
    end
  end
end