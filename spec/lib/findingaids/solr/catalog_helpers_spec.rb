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
    subject { catalog_helper.facet_fields }
    it { should be_instance_of Array }
  end

  describe ".pf_fields" do
    subject { catalog_helper.pf_fields }
    it { should eql "title_ssm^2000.0 parent_unittitles_ssm^500.0 collection_teim^1000.0 title_tesim^1000.0 title_teim^1000.0 subject_teim^250.0 abstract_teim^250.0 controlaccess_teim^100.0 scopecontent_teim^90.0 bioghist_teim^80.0 unittitle_teim^70.0 odd_teim^60.0 index_teim^50.0 phystech_teim^40.0 acqinfo_teim^30.0 sponsor_teim^20.0 custodhist_teim^10.0" }
  end

end
