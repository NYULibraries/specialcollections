require "spec_helper"

describe DocumentHelper do
  
  before :each do
    class TestDocumentHelper
      include DocumentHelper
    end
    @test = TestDocumentHelper.new
  end
  
  describe ".render_field_name" do
    xit "should return the field value" do
      @test.render_field_name(@response).should ""
    end
  end


end