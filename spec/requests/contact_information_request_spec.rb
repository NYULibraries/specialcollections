require 'spec_helper'

describe "contact information" do
  it "returns the Contact information page" do
    get "/help/contact_information"
    expect(response.status).to be == 200
    expect(response.body).to include("New York University Polytechnic School of Engineering")
  end
end
