require 'rails_helper'

describe Findingaids::Solr::CatalogHelpers do

  let(:catalog_helper) { Class.new { include Findingaids::Solr::CatalogHelpers } }

  describe ".solr_name" do
    context "when trying to retreive the repository fields as facetable" do
      subject { catalog_helper.solr_name("repository", :facetable) }
      it { is_expected.to eql "repository_sim" }
    end
  end

  describe ".display_fields" do
    subject { catalog_helper.display_fields }
    it { is_expected.to eql "*" }
  end

  describe ".qf_fields" do
    subject { catalog_helper.qf_fields }
    it { is_expected.to eql  "unittitle_teim^145.0 parent_unittitles_teim collection_teim unitid_teim^60 collection_unitid_teim^40 language_ssm unitdate_start_teim unitdate_end_teim unitdate_teim name_teim subject_teim^60.0 abstract_teim^55.0 creator_teim^60.0 scopecontent_teim^60.0 bioghist_teim^55.0 title_teim material_type_teim place_teim dao_teim chronlist_teim appraisal_teim custodhist_teim^15 acqinfo_teim^20.0 address_teim note_teim^30.0 phystech_teim^30.0 author_teim^10.0" }
  end

  describe ".facet_fields" do
    let(:facet_fields) { catalog_helper.facet_fields }
    context "when looking at the field keys" do
      subject { facet_fields.map { |field| field[:field] } }
      it { is_expected.to eql ["repository", "dao", "creator", "date_range", "subject", "name", "place", "language", "collection", "format"] }
    end
    context "when looking at the field label values" do
      subject { facet_fields.map { |field| field[:label] } }
      it { is_expected.to eql ["Library", "Digital Content", "Creator", "Date Range", "Subject", "Name", "Place", "Language", "Collection", "Level"] }
    end
  end

  describe ".pf_fields" do
    subject { catalog_helper.pf_fields }
    it { is_expected.to eql "unittitle_teim^145.0 parent_unittitles_teim collection_teim unitid_teim^60 collection_unitid_teim^40 language_ssm unitdate_start_teim unitdate_end_teim unitdate_teim name_teim subject_teim^60.0 abstract_teim^55.0 creator_teim^60.0 scopecontent_teim^60.0 bioghist_teim^55.0 title_teim material_type_teim place_teim dao_teim chronlist_teim appraisal_teim custodhist_teim^15 acqinfo_teim^20.0 address_teim note_teim^30.0 phystech_teim^30.0 author_teim^10.0" }
  end

  describe ".bq_fields" do
    subject { catalog_helper.bq_fields }
    it { is_expected.to eql ["format_sim:\"Archival Collection\"^250", "level_sim:series^150", "level_sim:subseries^50", "level_sim:file^20", "level_sim:item"] }
  end

  describe ".advanced_search_fields" do
    let(:advanced_search_fields) { catalog_helper.advanced_search_fields }
    context "when looking at the field keys" do
      subject { advanced_search_fields.map {|field| field[:field] } }
      it { is_expected.to include "unittitle" }
      it { is_expected.to include "unitid" }
      it { is_expected.to include "collection" }
    end
    context "when looking at the field label values" do
      subject { advanced_search_fields.map { |field| field[:label] } }
      it { is_expected.to include "Title" }
      it { is_expected.to include "Call No." }
      it { is_expected.to include "Collection" }
    end
  end

end
