require 'spec_helper'

describe Findingaids::Ead::Component do

  let(:document) do
    Findingaids::Ead::Component.from_xml(ead_fixture("ead_component.xml"))
  end
  let(:additional_fields) do
    {
      "id" => "TEST-0001ref010",
      Solrizer.solr_name("collection", :facetable)                => "Bytsura",
      Solrizer.solr_name("ead", :stored_sortable)                 => "TEST-0001",
      Solrizer.solr_name("parent", :stored_sortable)              => "ref001",
      Solrizer.solr_name("parent", :displayable)                  => ["ref001", "ref002", "ref003"],
      Solrizer.solr_name("parent_unittitles", :displayable)       => ["Series I", "Subseries A", "Subseries 1"],
      Solrizer.solr_name("component_children", :type => :boolean) => FALSE
    }
  end
  
  describe "#to_solr" do

    let(:solr_doc) { document.to_solr(additional_fields) }

    it { expect(solr_doc["id"]).to eql("TEST-0001ref010") }
    it { expect(solr_doc[Solrizer.solr_name("level", :facetable)]).to include "item" }
    it { expect(solr_doc[Solrizer.solr_name("location", :displayable)]).to include "Box: 1, Folder: 1" }
      
  end
  
end