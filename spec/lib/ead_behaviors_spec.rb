require 'spec_helper'

describe Findingaids::Ead::Behaviors do
  
  include Findingaids::Ead::Behaviors
  
  describe ".format_publisher" do
    
    it "should strip ugly characters from publisher" do
      expect(format_publisher(["@ 2012 Fales Library and Special Collections     "])).to eql("Fales Library and Special Collections")
    end
    
  end
  
  describe ".format_repository" do
    
    subject { format_repository }
    
    context "when EAD variable is a folder" do
      before { stub_const('ENV', {'EAD' => 'spec/fixtures/ead'}) }

      it { should eql("ead") }
    end
    
    context "when EAD variable is a file" do
      before { stub_const('ENV', {'EAD' => 'spec/fixtures/ead/bytsura.xml'}) }
      
      it { should eql("ead")}
    end
    
    context "when there is no EAD variable" do
      it { should be_nil }
    end
    
  end
  
  describe ".get_language_from_code" do
    
    let(:language_code) { "eng" }
    
    subject { get_language_from_code(language_code) }
    
    context "when language code is eng" do
      it { should eql("English") }
    end
    
    context "when language code is ger" do
      let(:language_code) { "ger" }
      it { should eql("German") }
    end
    
  end

end