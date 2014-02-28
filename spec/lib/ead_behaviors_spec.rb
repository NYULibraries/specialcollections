require 'spec_helper'

describe Findingaids::Ead::Behaviors do
  
  include Findingaids::Ead::Behaviors
  
  describe ".format_publisher" do
    
    it "should strip ugly characters from publisher" do
      format_publisher(["@ 2012 Fales Library and Special Collections     "]).should eq("Fales Library and Special Collections")
    end
    
  end
  
  describe ".format_repository" do
    
    it "should return the repository name from the folder" do
      stub_const('ENV', {'EAD' => 'spec/fixtures/ead'})
      format_repository.should eq("ead")
    end
    
    it "should return the repository name from the single file" do
      stub_const('ENV', {'EAD' => 'spec/fixtures/ead/bytsura.xml'})
      format_repository.should eq("ead")
    end
    
    it "should return nil without an EAD env var" do
      format_repository.should be_nil
    end
    
  end
  
  describe ".get_language_from_code" do
    
    it "should return full language name from code" do
      get_language_from_code("eng").should eq("English")
    end
    
  end

end