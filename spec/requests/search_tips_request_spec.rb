require 'spec_helper'

describe "search tips" do
  it "returns the Search tips page" do
    get "/help/search_tips"
    expect(response.status).to be == 200
  end
end
