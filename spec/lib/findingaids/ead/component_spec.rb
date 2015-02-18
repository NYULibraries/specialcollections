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
      Solrizer.solr_name("collection", :facetable)                => "Bill Bytsura ACT UP Photography Collection",
      Solrizer.solr_name("ead", :stored_sortable)                 => "TEST-0001",
      Solrizer.solr_name("parent", :stored_sortable)              => "ref001",
      Solrizer.solr_name("parent", :displayable)                  => parent,
      Solrizer.solr_name("parent_unittitles", :displayable)       => parent_unittitles,
      Solrizer.solr_name("component_children", :type => :boolean) => FALSE
    }
  end

  describe "#to_solr" do

    subject(:solr_doc) { document.to_solr(additional_fields) }

    describe "creator facet" do
      it { expect(solr_doc[Solrizer.solr_name("creator", :facetable)]).to include "Bytsura, Bill" }
    end

    describe "name facet" do
      it { expect(solr_doc[Solrizer.solr_name("name", :facetable)]).to include "Component Corp Inc." }
    end

    describe "place facet" do
      it { expect(solr_doc[Solrizer.solr_name("place", :facetable)]).to include "Cambridge (Mass.)" }
      it { expect(solr_doc[Solrizer.solr_name("place", :facetable)]).to include "Spain -- History -- Civil War, 1936-1939 -- Atrocities." }

    end

    describe "material type facet" do
      it { expect(document.material_type).to include "Clippings (information artifacts)" }
      it { expect(document.material_type).to include "Material Type" }
    end

    describe "collection facet" do
      it { expect(solr_doc[Solrizer.solr_name("collection", :facetable)]).to include "Bill Bytsura ACT UP Photography Collection" }
    end

    context "when component has parent titles" do
      it { expect(solr_doc["id"]).to eql("TEST-0001ref010") }
      it { expect(solr_doc[Solrizer.solr_name("level", :facetable)]).to include "item" }
      it { expect(solr_doc[Solrizer.solr_name("location", :displayable)]).to include "Box: 1, Folder: 1" }
    end

    context "when component doesn't have a title" do
      let(:document) { Findingaids::Ead::Component.from_xml(ead_fixture("ead_component2.xml")) }
      it { expect(solr_doc[Solrizer.solr_name("heading", :displayable)]).to include "August 19, 1992" }
    end

    describe "describe digital content facet" do
      it { expect(solr_doc[Solrizer.solr_name("dao", :facetable)]).to include "Online Access" }
    end

  end

  describe ".title_for_heading" do
    let(:parent_unittitles) { nil }
    let(:solr_doc) { document.to_solr(additional_fields) }

    it { expect(document.send(:title_for_heading)).to eql("[ACT UP Paris]") }
  end

end
