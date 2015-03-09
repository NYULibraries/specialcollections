require 'spec_helper'

describe Findingaids::Ead::Document do

  let(:document) { Findingaids::Ead::Document.from_xml(ead_fixture("EAD_Tracer.xml")) }

  subject { document }

  # Check "include" because these are all multi-valued fields in Solr
  its(:eadid) { should include "Resource-EAD-ID-AT" }
  its(:unittitle) { should eql ["Resource--Title-AT"] }
  its(:author) { should eql ["Finding aid prepared by Resource-FindingAidAuthor-AT"] }
  # Proxy for unittitle at the collection level
  its(:collection) { should eql ["Resource--Title-AT"] }
  its(:unitid) { should eql ["Resource.ID.AT.AT"] }
  its(:langcode) { should eql ["eng"] }
  its(:unitdate_normal) { should include "1960/1970" }
  its(:unitdate_bulk) { should eql ["Bulk, 1960-1970"] }
  its(:unitdate_inclusive) { should eql ["Resource-Date-Expression-AT"] }
  its(:abstract) { should eql ["Resource-Abstract-AT"] }
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
  its("subject.count") { should eql 2 }
  its(:title) { should include "Subjects--Uniform Title--AT" }
  its("title.count") { should eql 1 }
  its(:note) { should be_empty } # No examples for note

  describe "#heading" do
    let(:solr_doc) { document.to_solr }
    subject { solr_doc[Solrizer.solr_name("heading", :displayable)] }
    it { should eql ["Resource--Title-AT"] }
  end

  describe "unitdate" do
    let(:solr_doc) { document.to_solr }
    subject { solr_doc[Solrizer.solr_name("unitdate", :displayable)] }
    it { should eql ["Inclusive, Resource-Date-Expression-AT ; Bulk, 1960-1970"] }
  end

  describe "facets" do
    let(:solr_doc) { document.to_solr }
    let(:facet) { 'creator' }
    subject { solr_doc[Solrizer.solr_name(facet, :facetable)] }

    context "when the facet is Creator" do
      it { should_not be_empty }
      its(:size) { should be 3 }
    end
    context "when the facet is Digital Content" do
      let(:facet) { 'dao' }
      it { should include "Online Access" }
    end
    context "when the facet is Subject" do
      let(:facet) { 'subject' }
      it { should include "c06-index1" }
      it { should_not include "SubjectsUgly |z Topical Term |x AT" }
      its(:size) { should be 5 }
    end
    context "when the facet is Place" do
      let(:facet) { 'place' }
      it { should include "Subjects--Geographic Name--AT" }
    end
    context "when the facet is Name" do
      let(:facet) { 'name' }
      it { should_not be_empty }
      it { should_not include "Archivists' Toolkit Migration Tracer" }
      it { should include "CNames-PrimaryName-AT -- CNames-Subordinate1-AT -- CNames-Subordiate2-AT" }
      it { should_not include "CNames-PrimaryName-AT |z CNames-Subordinate1-AT |x CNames-Subordiate2-AT" }
      its(:size) { should be 17 }
    end
    context "when the facet is Material Type" do
      let(:facet) { 'material_type' }
      it { should include "SubjectsUgly -- GenreForm -- AT"}
      it { should_not include "SubjectsUgly |z GenreForm |x AT" }
    end
    context "when the facet is Collection" do
      let(:facet) { 'collection' }
      it { should include "Resource--Title-AT" }
    end
    context "when the facet is Unitdate Start" do
      let(:facet) { 'unitdate_start' }
      it { should eql ["1960"] }
    end
    context "when the facet is Unitdate End" do
      let(:facet) { 'unitdate_end' }
      it { should eql ["1970"] }
    end
    context "when the facet is Date Range" do
      let(:facet) { 'date_range' }
      it { should eql ["1901-2000"] }
    end
  end

end
