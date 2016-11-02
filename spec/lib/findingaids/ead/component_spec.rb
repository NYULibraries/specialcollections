require 'rails_helper'

##
# Test as much of the index structure of the component as possible from the examples available to us
describe Findingaids::Ead::Component do

  let(:document) { Findingaids::Ead::Component.from_xml(ead_fixture("ead_series.xml")) }

  subject { document }

  context "when component is series level" do
    its(:unittitle) { should eql ["Resource-C02-AT"] }
    its(:level) { should eql ["series"] }
    its(:container_label) { should eql ["Text (Resource C02 Instance Barcode)"] }
    its(:container_type) { should eql ["Box", "Folder", "Item"] }
    its(:container_id) { should eql ["cid2"] }
    its(:unitid) { should eql ["Resource-C02-ID-AT"] }
    its(:langcode) { should eql ["eng"] }
    its(:unitdate_normal) { should eql ["1999/2000", "1999/2000"] }
    its(:unitdate_inclusive) { should eql ["Resource-C01-Date-AT"] }
    its(:unitdate_bulk) { should eql ["Bulk, 1999-2000"] }
    its(:creator) { should eql ["PNames-Primary-AT, PNames-RestOfName-AT, PNames-Prefix-AT, PName-Number-AT, PNames-Suffix-AT, PNames-Title-AT,  (PNames-FullerForm-AT), PNames-Dates-AT, PNames-Qualifier-AT"] }
    its(:scopecontent) { should eql ["Resource-C01-ScopecontentNoteContent-AT"] }
    its(:bioghist) { should be_blank }
    its(:address) { should be_blank }
    its(:appraisal) { should be_blank }
    its(:chronlist) { should be_blank }
    its(:corpname) { should_not be_blank }
    its("corpname.count") { should eql 1 }
    its(:famname) { should_not be_blank }
    its(:function) { should_not be_blank }
    its(:genreform) { should_not be_blank }
    its(:geogname) { should_not be_blank }
    its(:phystech) { should_not be_blank }
    its(:name) { should be_blank }
    its(:occupation) { should_not be_blank }
    its(:persname) { should include "PNames-Primary-AT, PNames-RestOfName-AT, PNames-Prefix-AT, PName-Number-AT, PNames-Suffix-AT, PNames-Title-AT,  (PNames-FullerForm-AT), PNames-Dates-AT, PNames-Qualifier-AT" }
    its(:subject) { should eql ["Subjects--Topical Term--AT"] }
    its(:title) { should_not be_blank }
    its(:note) { should be_blank }
    its(:dao) { should eql ["DO.Title-AT, 1999-2000 (DO.Label-AT)"] }
  end

  context "when component is file level" do
    let(:document) { Findingaids::Ead::Component.from_xml(ead_fixture("ead_file.xml")) }

    its(:unittitle) { should eql ["Resource-C06-AT"] }
    its(:level) { should eql ["file"] }
    its(:container_label) { should eql ["Text (Resource C06 Instance Barcode)"] }
    its(:container_type) { should eql ["Box", "Folder", "Item"]}
    its(:container_id) { should eql ["cid6"] }
    its(:unitid) { should eql ["Resource-C06-ID-AT"] }
    its(:langcode) { should eql ["eng"] }
    its(:unitdate_inclusive) { should eql ["Resource-C06-Date-AT"] }
    its(:unitdate_bulk) { should eql ["Bulk, 1960-1970"] }
    its(:unitdate_normal) { should eql ["1960/1970", "1960/1970"] }
    its(:creator) { should include "CNames-PrimaryName-AT. CNames-Subordinate1-AT. CNames-Subordiate2-AT. (CNames-Number-AT) (CNames-Qualifier-AT)" }
    its("creator.count") { should eql 3 }
    its(:scopecontent) { should be_blank }
    its(:bioghist) { should eql ["c06--biogHist-part1", "Resource-c06-BiogHist-EndPart"] }
    its(:address) { should be_blank }
    its(:appraisal) { should be_blank }
    its(:chronlist) { should_not be_blank }
    its(:corpname) { should include "CNames-PrimaryName-AT. CNames-Subordinate1-AT. CNames-Subordiate2-AT. (CNames-Number-AT) (CNames-Qualifier-AT)" }
    its("corpname.count") { should eql 2 }
    its(:famname) { should include "c06-index2" }
    its("famname.count") { should eql 3 }
    its(:function) { should eql ["c06-index1", "Subjects--Function-AT"] }
    its(:genreform) { should eql ["Subjects--GenreForm--AT", "SubjectsUgly |z GenreForm |x AT"] }
    its(:geogname) { should eql ["Subjects--Geographic Name--AT"] }
    its(:name) { should be_blank }
    its(:occupation) { should eql ["Subjects--Occupation--AT"] }
    its(:persname) { should include "PNames-Primary-AT, PNames-RestOfName-AT, PNames-Prefix-AT, PName-Number-AT, PNames-Suffix-AT, PNames-Title-AT,  (PNames-FullerForm-AT), PNames-Dates-AT, PNames-Qualifier-AT" }
    its("persname.count") { should eql 3 }
    its(:subject) { should eql ["Subjects--Topical Term--AT", "SubjectsUgly |z Topical Term |x AT"] }
    its("subject.count") { should eql 2 }
    its(:title) { should eql ["Subjects--Uniform Title--AT"] }
    its(:note) { should be_blank }
    its(:dao) { should eql ["DO.Title-AT, 1999-2000 (DO.Label-AT)"] }
  end

  describe "#to_solr" do
    let(:additional_fields) do
      {
        "id"                                                        => "TEST-0001ref010",
        Solrizer.solr_name("ead", :stored_sortable)                 => "TEST-0001",
        Solrizer.solr_name("parent", :stored_sortable)              => "ref001",
        Solrizer.solr_name("parent", :displayable)                  => ["ref001", "ref002", "ref003"],
        Solrizer.solr_name("parent_unittitles", :displayable)       => ["Series I", "Subseries A", "Subseries 1"],
        Solrizer.solr_name("component_children", :type => :boolean) => FALSE,
        Solrizer.solr_name("collection", :facetable)                => ["Resource--Title-AT"],
        Solrizer.solr_name("collection_unitid", :displayable)       => ["Resource.ID.AT.AT"],
        Solrizer.solr_name("author", :searchable)                   => ["Finding aid prepared by Resource-FindingAidAuthor-AT"]
      }
    end
    let(:document) { Findingaids::Ead::Component.from_xml(ead_fixture("ead_file.xml")) }
    let(:solr_doc) { document.to_solr(additional_fields) }

    describe "chronlist" do
      subject { solr_doc[Solrizer.solr_name("chronlist", :searchable)] }
      it { should eql ["1895", "Event1", "Event2", "1995", "Event A", "Event B"] }
    end

    describe "author" do
      subject { solr_doc[Solrizer.solr_name("author", :searchable)] }
      it { should eql ["Finding aid prepared by Resource-FindingAidAuthor-AT"] }
    end

    describe "unitdate" do
      subject { solr_doc[Solrizer.solr_name("unitdate", :displayable)] }
      it { should eql ["Inclusive, Resource-C06-Date-AT ; Bulk, 1960-1970"] }
    end

    describe "collection_unitid" do
      subject { solr_doc[Solrizer.solr_name("collection_unitid", :displayable)] }
      it { should eql ["Resource.ID.AT.AT"] }
    end

    describe "facets" do
      subject { solr_doc[Solrizer.solr_name(facet, :facetable)] }
      context "when the facet is Creator" do
        let(:facet) { 'creator' }
        it { should_not be_blank }
        its(:count) { should eql 3 }
      end
      context "when the facet is Subject" do
        let(:facet) { 'subject' }
        it { should include "c06-index1" }
        it { should_not include "SubjectsUgly |z Topical Term |x AT" }
        its(:size) { should be 5 }
      end
      context "when the facet is Format" do
        let(:facet) { 'format' }
        context "when the component is a file" do
          it { should eql ["Archival Object"] }
        end
        context "when the component is a series" do
          let(:document) { Findingaids::Ead::Component.from_xml(ead_fixture("ead_series.xml")) }
          let(:solr_doc) { document.to_solr(additional_fields) }
          it { should eql ["Archival Series"] }
        end
      end
      context "when the facet is Name" do
        let(:facet) { 'name' }
        it { should_not be_blank }
        its(:count) { should eql 8 }
        it { should_not include "PNames-Primary-AT-Ugly |z PNames-RestOfName-AT-Ugly" }
        it { should include "PNames-Primary-AT-Ugly -- PNames-RestOfName-AT-Ugly" }
      end
      context "when the facet is Digital Access" do
        let(:facet) { 'dao' }
        it { should eql ["Online Access"] }
      end
      context "when the facet is Place" do
        let(:facet) { 'place' }
        it { should eql ["Subjects--Geographic Name--AT"] }
      end
      context "when the facet is Collection" do
        let(:facet) { 'collection' }
        it { should eql ["Resource--Title-AT"] }
      end
      context "when the facet is Series" do
        let(:facet) { 'series' }
        it { should eql ["Series I", "Subseries A", "Subseries 1"] }
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


    describe "#location_display" do
      subject { solr_doc[Solrizer.solr_name("location", :displayable)] }
      it { should eql ["Box: 6, Folder: 6, Item: 6"] }
    end

    describe "#heading" do
      subject { solr_doc[Solrizer.solr_name("heading", :displayable)] }
      it { should eql ["Resource-C06-AT"] }
    end
  end

end
