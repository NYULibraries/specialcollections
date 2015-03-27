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
    it { should eql "title_ssm^2000.0 parent_unittitles_ssm^500.0 collection_teim^1000.0 title_tesim^1000.0 title_teim^1000.0 subject_teim^250.0 abstract_teim^250.0 controlaccess_teim^100.0 scopecontent_teim^90.0 bioghist_teim^80.0 unittitle_teim^70.0 odd_teim^60.0 index_teim^50.0 phystech_teim^40.0 acqinfo_teim^30.0 sponsor_teim^20.0 custodhist_teim^10.0" }
  end

  describe ".facet_fields" do
    let(:facet_fields) { catalog_helper.facet_fields }
    context "when looking at the field keys" do
      subject { facet_fields.map { |field| field[:field] } }
      it { should eql ["repository", "dao", "creator", "date_range", "subject", "name", "place", "material_type", "language", "collection", "format"] }
    end
    context "when looking at the field label values" do
      subject { facet_fields.map { |field| field[:label] } }
      it { should eql ["Library", "Digital Content", "Creator", "Date Range", "Subject", "Name", "Place", "Material Type", "Language", "Collection", "Format"] }
    end
  end

  describe ".pf_fields" do
    subject { catalog_helper.pf_fields }
    it { should eql "title_ssm^2000.0 parent_unittitles_ssm^500.0 collection_teim^1000.0 title_tesim^1000.0 title_teim^1000.0 subject_teim^250.0 abstract_teim^250.0 controlaccess_teim^100.0 scopecontent_teim^90.0 bioghist_teim^80.0 unittitle_teim^70.0 odd_teim^60.0 index_teim^50.0 phystech_teim^40.0 acqinfo_teim^30.0 sponsor_teim^20.0 custodhist_teim^10.0" }
  end

  describe ".advanced_search_fields" do
    let(:advanced_search_fields) { catalog_helper.advanced_search_fields }
    context "when looking at the field keys" do
      subject { advanced_search_fields.map { |field| field[:field] } }
      it { should eql ["unittitle", "name", "subject", "unitid", "creator", "place", "material_type", "language"] }
    end
    context "when looking at the field label values" do
      subject { advanced_search_fields.map { |field| field[:label] } }
      it { should eql ["Title", "Name", "Subject", "Call No.", "Creator", "Place", "Material Type", "Language"] }
    end
  end

end
