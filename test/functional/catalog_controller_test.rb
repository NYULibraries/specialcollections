require 'test_helper'

class CatalogControllerTest < ActionController::TestCase
  
  setup do
    activate_authlogic
    # Pretend we've already checked PDS/Shibboleth for the session
    # and we have a session
    @request.cookies[:attempted_sso] = { value: "true" }
    @controller.session[:session_id] = "FakeSessionID"
  end
  
  test "should search indexed records" do
     VCR.use_cassette('blacklight search', :match_requests_on => [:body]) do
       post :index, :q => "Charles Adler", :search_field => "All Collections"
     end
     assert_template :index
  end
  
  test "should match components and do another solr search" do
    VCR.use_cassette('component search', :match_requests_on => [:body]) do
       post :index, :q => "family papers", :search_field => "All Collections"
     end
     assert_template :index
  end
  
  test "should match dsc path without components" do
    VCR.use_cassette('component search without results', :match_requests_on => [:body]) do
       post :index, :q => "Tony Alleyne", :search_field => "All Collections"
     end
     assert_template :index
  end
  
end
