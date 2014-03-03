require 'spec_helper'

describe ApplicationController do

  describe "#repositories" do
    it "should return hash of repositories" do
      expect(subject.repositories).to eq({"fales"=>{"display"=>"The Fales Library & Special Collections", "url"=>"fales", "admin_code"=>"fales"}, "tamwag"=>{"display"=>"The Tamiment Library & Robert F. Wagner Labor Archives", "url"=>"tamwag", "admin_code"=>"tamwag"}, "archives"=>{"display"=>"New York University Archives", "url"=>"archives", "admin_code"=>"archives"}, "nyhs"=>{"display"=>"New-York Historical Society", "url"=>"nyhs", "admin_code"=>"nyhs"}, "bhs"=>{"display"=>"Brooklyn Historical Society", "url"=>"bhs", "admin_code"=>"bhs"}, "poly"=>{"display"=>"Poly Archives", "url"=>"poly", "admin_code"=>"poly"}, "rism"=>{"display"=>"Research Institue for the Study of Man", "url"=>"rism", "admin_code"=>"rism"}})
    end
  end

end