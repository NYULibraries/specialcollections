require 'spec_helper'

describe HelpController do

  describe "GET /help/contact_information" do
    it "should get contaction information page" do
      get :contact_information
      expect(response).to render_template(:contact_information)
    end
  end

  describe "GET /help/search_tips" do
    it "should get search tips page" do
      get :search_tips
      expect(response).to render_template(:search_tips)
    end
  end

end
