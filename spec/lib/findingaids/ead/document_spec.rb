require 'spec_helper'

describe Findingaids::Ead::Document do

  let(:document) { Findingaids::Ead::Document.from_xml(ead_fixture("EAD_Tracer.xml")) }

  subject { document }

  # Check "include" because these are all multi-valued fields in Solr
  its(:eadid) { should include "Resource-EAD-ID-AT" }
  its(:unittitle) { should include "Resource--Title-AT" }
  # Proxy for unittitle at the collection level
  its(:collection) { should include "Resource--Title-AT" }
  its(:unitid) { should include "Resource.ID.AT.AT" }
  its(:langcode) { should include "eng" }
  its(:unitdate) { should include "1960/1970" }
  its(:abstract) { should include "Resource-Abstract-AT" }
  its(:creator) { should include "CNames-PrimaryName-AT. CNames-Subordinate1-AT. CNames-Subordiate2-AT. (CNames-Number-AT) (CNames-Qualifier-AT)" }
  its(:scopecontent) { should include "Resource-ScopeContents-AT" }
  its(:scopecontent) { should_not include "Resource-C01-ScopecontentNoteContent-AT" }
  its(:bioghist) { should include "Resource-BiographicalHistorical-AT" }
  its(:bioghist) { should_not include "c06--biogHist-part1" }
  its(:acqinfo) { should include "Resource-ImmediateSourceAcquisition" }
  its(:custodhist) { should include "Resource--CustodialHistory-AT" }
  its(:appraisal) { should include "Resource-Appraisal-AT" }
  its(:chronlist) { should include "Christmas 1985" }
  its(:chronlist) { should_not include "first date" }
  its(:corpname) { should include "CNames-PrimaryName-AT. CNames-Subordinate1-AT. CNames-Subordiate2-AT. (CNames-Number-AT) (CNames-Qualifier-AT)" }
  its(:corpname) { should_not include "CNames-PrimaryName-AT. CNames-Subordinate1-AT. CNames-Subordiate2-AT. (CNames-Number-AT) (CNames-Qualifier-AT) -- Pictorial works" }
  its(:famname) { should include "FNames-FamilyName-AT, FNames-Prefix-AT, FNames-Qualifier-AT -- Archives" }
  its(:famname) { should_not include "FNames-FamilyName-AT, FNames-Prefix-AT, FNames-Qualifier-AT -- Pictorial works" }
  its(:function) { should include "Subjects--Function-AT" }
  its(:function) { should_not include "c06-index1" }
  its(:genreform) { should include "Subjects--GenreForm--AT" }
  # Proxy for genreform
  its(:material_type) { should include "Subjects--GenreForm--AT" }
  its(:genreform) { should_not include "Bike 1" }
  its(:geogname) { should include "Subjects--Geographic Name--AT" }
  # No lower level examples, so make sure the value doesn't repeat
  its("geogname.count") { should eql 1 }
  its(:name) { should be_empty } # No examples for name
  its(:occupation) { should include "Subjects--Occupation--AT" }
  its("occupation.count") { should eql 1 }
  its(:persname) { should include "PNames-Primary-AT, PNames-RestOfName-AT, PNames-Prefix-AT, PName-Number-AT, PNames-Suffix-AT, PNames-Title-AT,  (PNames-FullerForm-AT), PNames-Dates-AT, PNames-Qualifier-AT" }
  # Only 3 persnames at the top-level, don't include the lower ones
  its("persname.count") { should eql 3 }
  its(:subject) { should include "Subjects--Topical Term--AT" }
  its("subject.count") { should eql 1 }
  its(:title) { should include "Subjects--Uniform Title--AT" }
  its("title.count") { should eql 1 }
  its(:note) { should be_empty } # No examples for note

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
