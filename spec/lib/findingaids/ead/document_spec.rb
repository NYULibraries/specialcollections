require 'spec_helper'

describe Findingaids::Ead::Document do

  let(:document) { Findingaids::Ead::Document.from_xml(ead_fixture("ead_template.xml")) }

  subject { document }

  its(:eadid) { should include "sample_ead" }
  its(:unittitle) { should include "Bill Bytsura ACT UP Photography Collection" }
  its(:unitid) { should include "ARC.0161" }
  its(:langcode) { should include "eng" }
  its(:unitdate) { should include "2010/2012" }
  its(:abstract) { should_not be_empty }
  its(:creator) { should include "" }
  its(:scopecontent) { should_not be_empty }
  its(:bioghist) { should_not be_empty }
  its(:acqinfo) { should_not be_empty }
  its(:custodhist) { should include "" }
  its(:appraisal) { should_not be_empty }
  its(:chronlist) { should be "" }
  its(:corpname) { should include "" }
  its(:famname) { should include "" }
  its(:function) { should include "" }
  its(:genreform) { should include "" }
  its(:geogname) { should include "" }
  its(:name) { should include "" }
  its(:occupation) { should include "" }
  its(:persname) { should include "" }
  its(:subject) { should include "" }
  its(:title) { should include "" }
  its(:note) { should include "" }

  describe "#to_solr" do

  end

  describe "facets" do
  end
  # describe "creator facet" do
  #   it { expect(solr_doc[Solrizer.solr_name("creator", :facetable)]).to eql ["Belfrage, Sally, 1936-", "Bytsura, Bill", "Component Level Name", "Kings County (N.Y.). Board of Supervisors.", "Lefferts family"] }
  # end
  #
  # describe "digital content facet" do
  #   it { expect(solr_doc[Solrizer.solr_name("dao", :facetable)]).to include "Online Access" }
  # end
  #
  # describe "name facet" do
  #   it { expect(solr_doc[Solrizer.solr_name("name", :facetable)]).to include "Gay Men's Health Crisis, Inc.." }
  # end
  #
  # describe "material type facet" do
  #   it { expect(document.material_type).to include "Material Type" }
  #   it { expect(document.material_type).to include "Buttons (information artifacts)" }
  # end
  #
  # describe "collection facet" do
  #   it { expect(document.collection).to include "Bill Bytsura ACT UP Photography Collection" }
  # end
  #
  # describe "date display" do
  #   context "when there is a valid date" do
  #     it { expect(document.unitdate).to include "Inclusive, 1981-2012 ; Bulk, 1989-1997" }
  #   end
  #
  #   context "when there is no valid date" do
  #     let(:document) { Findingaids::Ead::Document.from_xml(ead_fixture("ead_template.xml")) }
  #     it { expect(document.unitdate).to include "sample date" }
  #   end
  # end

end
