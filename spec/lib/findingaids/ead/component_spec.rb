require 'spec_helper'

describe Findingaids::Ead::Component do

  let(:document) do
    Findingaids::Ead::Component.from_xml(ead_fixture("ead_component.xml"))
  end
  let(:parent_unittitles) { ["Series I", "Subseries A", "Subseries 1"] }
  let(:parent) { ["ref001", "ref002", "ref003"] }
  let(:additional_fields) do
    {
      "id" => "TEST-0001ref010",
      Solrizer.solr_name("collection", :facetable)                => "Bytsura",
      Solrizer.solr_name("ead", :stored_sortable)                 => "TEST-0001",
      Solrizer.solr_name("parent", :stored_sortable)              => "ref001",
      Solrizer.solr_name("parent", :displayable)                  => parent,
      Solrizer.solr_name("parent_unittitles", :displayable)       => parent_unittitles,
      Solrizer.solr_name("component_children", :type => :boolean) => FALSE
    }
  end
  
  describe "#to_solr" do

    subject(:solr_doc) { document.to_solr(additional_fields) }

    context "when component has parent titles" do
      it { expect(solr_doc["id"]).to eql("TEST-0001ref010") }
      it { expect(solr_doc[Solrizer.solr_name("level", :facetable)]).to include "item" }
      it { expect(solr_doc[Solrizer.solr_name("location", :displayable)]).to include "Box: 1, Folder: 1" }
    end
        
    context "when component doesn't have a title" do
      let(:document) { Findingaids::Ead::Component.from_xml(ead_fixture("ead_component2.xml")) }
      it { expect(solr_doc[Solrizer.solr_name("heading", :displayable)]).to include "August 19, 1992" }
    end
    
  end
  
  describe ".title_for_heading" do  
    let(:parent_unittitles) { nil }
    let(:solr_doc) { document.to_solr(additional_fields) }
    
    it { expect(document.send(:title_for_heading)).to eql("[ACT UP Paris]") }
  end
  
end