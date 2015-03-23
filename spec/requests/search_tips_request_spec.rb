require 'spec_helper'

describe "search tips" do
  it "returns the Search tips page" do
    get "/search_tips"
    expect(response.status).to be eq(200)
  end
end
