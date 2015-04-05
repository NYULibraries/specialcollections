require 'spec_helper'

describe Findingaids::Solr::CatalogHelpers do

  let(:catalog_helper) { Class.new { include Findingaids::Solr::CatalogHelpers } }

  describe ".solr_name" do
    context "when trying to retreive the repository fields as facetable" do
      subject { catalog_helper.solr_name("repository", :facetable) }
      it { should eql "repository_sim" }
    end
  end

  describe ".display_fields" do
    subject { catalog_helper.display_fields }
    it { should eql "*" }
  end

  describe ".qf_fields" do
    subject { catalog_helper.qf_fields }
    it { should eql "unittitle_teim^145.0 parent_unittitles_teim collection_teim unitid_teim^60 language_ssm unitdate_start_teim unitdate_end_teim unitdate_teim name_teim subject_teim^60.0 abstract_teim^55.0 creator_teim^60.0 scopecontent_teim^60.0 bioghist_teim^55.0 title_teim material_type_teim place_teim dao_teim chronlist_teim appraisal_teim custodhist_teim^15 acqinfo_teim^20.0 address_teim note_teim^30.0 author_teim^10.0" }
  end

  describe ".facet_fields" do
    let(:facet_fields) { catalog_helper.facet_fields }
    context "when looking at the field keys" do
      subject { facet_fields.map { |field| field[:field] } }
      it { should eql ["repository", "dao", "creator", "date_range", "subject", "name", "place", "material_type", "language", "collection", "format"] }
    end
    context "when looking at the field label values" do
      subject { facet_fields.map { |field| field[:label] } }
      it { should eql ["Library", "Digital Content", "Creator", "Date Range", "Subject", "Name", "Place", "Material Type", "Language", "Collection", "Level"] }
    end
  end

  describe ".pf_fields" do
    subject { catalog_helper.pf_fields }
    it { should eql "unittitle_teim^145.0 parent_unittitles_teim collection_teim unitid_teim^60 language_ssm unitdate_start_teim unitdate_end_teim unitdate_teim name_teim subject_teim^60.0 abstract_teim^55.0 creator_teim^60.0 scopecontent_teim^60.0 bioghist_teim^55.0 title_teim material_type_teim place_teim dao_teim chronlist_teim appraisal_teim custodhist_teim^15 acqinfo_teim^20.0 address_teim note_teim^30.0 author_teim^10.0" }
  end

  describe ".advanced_search_fields" do
    let(:advanced_search_fields) { catalog_helper.advanced_search_fields }
    context "when looking at the field keys" do
      subject { advanced_search_fields.map { |field| field[:field] } }
      it { should include "unittitle" }
      it { should include "unitid" }
      it { should include "collection" }
    end
    context "when looking at the field label values" do
      subject { advanced_search_fields.map { |field| field[:label] } }
      it { should include "Title" }
      it { should include "Call No." }
      it { should include "Collection" }
    end
  end

end
