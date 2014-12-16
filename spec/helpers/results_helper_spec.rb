require "spec_helper"

describe ResultsHelper do

  include ApplicationHelper
  include BlacklightHelper
  include ActionView::Helpers::UrlHelper

  let(:repositories) do
    {"fales" => {"display" => "The Fales Library"}}
  end
  let(:title_ssm) { "The Title" }
  let(:field) { :title_ssm }
  let(:ref_ssi) { nil }
  let(:parent_ssm) { nil }
  let(:format_ssm) { "Archival Collection" }
  let(:heading) { "Guide to titling finding aids" }
  let(:heading_ssm) { [heading] }
  let(:ead_ssi) { "bytsura" }
  let(:highlight_field) { ead_ssi }
  let(:parent_unittitles_ssm) { nil }
  let(:collection_ssm) { "Bytsura Collection of Things" }
  let(:params) do
    {:controller => "catalog", :action => "index"}
  end
  let(:default_sort_hash) {{:sort => "series_si asc, box_filing_si asc"}}
  let(:solr_response) do
    Blacklight::SolrResponse.new(
    {
      :highlighting => {
        highlight_field => { :title_ssm => ["The <span class=\"highlight\">Title</span>"] }
      }
    }, :solr_parameters => {:qf => "fieldOne^2.3 fieldTwo fieldThree^0.4", :pf => "", :spellcheck => 'false', :rows => "55", :sort => "request_params_sort" }
    )
  end
  let(:document) do
    {
      :document => SolrDocument.new({
        :id => "#{ead_ssi}#{ref_ssi}",
        :format_ssm => [format_ssm],
        :title_ssm => [title_ssm],
        :abstract_ssm => ["The Abstract"],
        :repository_ssi => "fales",
        :ead_ssi => ead_ssi,
        :bioghist_ssm => ["Biographical something something"],
        :custodhist_ssm => ["This field contains info"],
        :ref_ssi => ref_ssi,
        :parent_ssm => parent_ssm,
        :heading_ssm => heading_ssm,
        :parent_unittitles_ssm => parent_unittitles_ssm,
        :collection_ssm => [collection_ssm]
      }, solr_response),
      :field => field
    }.with_indifferent_access
  end
  let(:blacklight_config) do
    @config ||= Blacklight::Configuration.new.configure do |config|
      config.index.title_field = "heading_ssm"
      config.index.display_type_field = "format_ssm"
      end
  end
  let(:source_params) do
    {
      :action => "index",
      :controller => "catalog",
      :id => "bytsura123",
      :commit => "true",
      :utf8 => "checky",
      :leftover => "Yup",
      :smorgas => nil
    }.with_indifferent_access
  end

  describe ".render_field_item" do

    let(:highlight_field) { "nohighlighting" }
    let(:collection) { document }

    subject { render_field_item(collection) }

    context "when the title is plain text" do
      it { should eql("The Title") }
    end

    context "when the title has html" do
      let(:title_ssm) { "<b>The Title</b>" }
      it { should be_html_safe }
      it { should eql("<b>The Title</b>") }
    end

    context "when the title has highlighting" do
      let(:highlight_field) { "bytsura" }
      it { should eql("The <span class=\"highlight\">Title</span>") }
    end

  end

  describe ".link_to_toc_page" do

    let(:collection) { document[:document] }
    subject { link_to_toc_page(collection, "Click Here", field) }

    context "when the field is the abstract" do
      let(:field) { "abstract" }
      it { should eql("<dd><a href=\"http://dlib.nyu.edu/findingaids/html/fales/bytsura/\" target=\"_blank\">Click Here</a></dd>") }
    end

    context "when the field is bioghist" do
      let(:field) { "bioghist" }
      it { should eql("<dd><a href=\"http://dlib.nyu.edu/findingaids/html/fales/bytsura/bioghist.html\" target=\"_blank\">Click Here</a></dd>") }
    end

    context "when the field is admininfo" do
      let(:field) { "admininfo" }
      it { should eql("<dd><a href=\"http://dlib.nyu.edu/findingaids/html/fales/bytsura/admininfo.html\" target=\"_blank\">Click Here</a></dd>") }
    end

    context "when the field is dsc" do
      let(:field) { "dsc" }
      it { should be_nil }
    end
  end

  describe ".sort_by_series" do
    it "should return a hash for sorting" do
      expect(sort_by_series).to eql(default_sort_hash)
    end
  end

  describe ".document_icon" do
    subject { document_icon(document[:document]) }

    context "when document is a collection level item" do
      it { should eql("archival_collection") }
    end
    context "when document is a series level item" do
      let(:format_ssm) { "Archival Series" }
      it { should eql("archival_series") }
    end
    context "when document is item level" do
      let(:format_ssm) { "Archival Item" }
      it { should eql("archival_item") }
    end
  end

  describe ".link_to_repository" do
    let(:collection) { "fales" }
    subject { link_to_repository(collection)}
    context "when document is a collection level item" do
      it { should eql("<a href=\"/fales\">The Fales Library</a>") }
    end

  end

  describe ".repository_label" do
    subject { repository_label(document[:document][:repository_ssi]) }
    it { should eq("The Fales Library") }
  end

  describe ".sanitize" do
    subject { sanitize("<b>Sanitize me!</b>") }
    it { should eq("Sanitize me!") }
  end

  describe ".facet_name" do
    it "should return the Solrized name of the facet" do
      expect(facet_name("test")).to eql("test_sim")
    end
  end

  describe ".collection_facet" do
    it "should alias facet_name function for collection facet" do
      expect(collection_facet).to eql("collection_sim")
    end
  end

  describe ".format_facet" do
    it "should alias facet_name function for format facet" do
      expect(format_facet).to eql("format_sim")
    end
  end

  describe ".series_facet" do
    it "should alias facet_name for series facet" do
      expect(series_facet).to eql("series_sim")
    end
  end

  describe ".sanitize_search_params" do
    subject { sanitize_search_params(source_params) }
    it { should eql({"leftover" => "Yup"}) }
  end

  describe ".reset_search_params" do
    let(:local_params) do
      source_params.merge({
        :leftover => "Yup",
        :smorgas => nil,
        :page => 1,
        :counter => 10,
        :q => "ephemera"
      }).with_indifferent_access
    end
    subject { reset_search_params(local_params) }
    it { should eql({"leftover" => "Yup"}) }
  end

  describe ".reset_facet_params" do
    let(:local_params) do
      source_params.merge({
        :leftover => "Yup",
        :smorgas => nil,
        :page => 1,
        :counter => 10,
        :q => "ephemera",
        :f => {:collection => "fales"}
      }).with_indifferent_access
    end
    subject { reset_facet_params(local_params) }
    it { should eql({"leftover" => "Yup"}) }
  end

  describe ".render_collection_facet_link" do
    subject { render_collection_facet_link(document) }
    let(:field) { :heading_ssm }
    it { should eql "<a href=\"/catalog?f%5Bcollection_sim%5D%5B%5D=Guide+to+titling+finding+aids&amp;f%5Bformat_sim%5D%5B%5D=Archival+Collection\">Guide to titling finding aids</a>" }
  end

  describe ".render_series_facet_link" do
    let(:field) { :parent_unittitles_ssm }
    let(:parent_unittitles_ssm) { ["Series I", "Subseries IV"] }
    subject { render_series_facet_link(document) }
    it { should eql "<a href=\"/catalog?f%5Bcollection_sim%5D%5B%5D=Bytsura+Collection+of+Things&amp;f%5Bseries_sim%5D%5B%5D=Series+I&amp;sort=series_si+asc%2C+box_filing_si+asc\">Series I</a> >> <a href=\"/catalog?f%5Bcollection_sim%5D%5B%5D=Bytsura+Collection+of+Things&amp;f%5Bseries_sim%5D%5B%5D=Subseries+IV&amp;sort=series_si+asc%2C+box_filing_si+asc\">Subseries IV</a>" }
    it { expect(sanitize(subject)).to eql("Series I &gt;&gt; Subseries IV") }
  end

  describe ".render_components_facet_link" do
    let(:field) { :parent_unittitles_ssm }
    let(:parent_unittitles_ssm) { ["Series I", "Subseries IV"] }
    subject { render_components_facet_link(document[:document]) }
    it { should eql({"f"=>{"collection_sim"=>[collection_ssm]}, "action"=>"index", "controller"=>"catalog", "sort"=>"series_si asc, box_filing_si asc"}) }
  end

  describe ".render_components_for_series_facet_link" do
    let(:field) { :parent_unittitles_ssm }
    let(:title_ssm) { "Series I" }
    subject { render_components_for_series_facet_link(document[:document]) }
    it { should eql({"f"=>{"series_sim"=>document[:document][:title_ssm], "collection_sim"=>[collection_ssm]}, "action"=>"index", "controller"=>"catalog", "sort"=>"series_si asc, box_filing_si asc"}) }
  end

  describe ".link_to_document" do

    subject { link_to_document(collection, { label: heading }) }
    let(:collection) { document[:document] }

    context "when document is a collection level item" do
      it { should eql("<a href=\"http://dlib.nyu.edu/findingaids/html/fales/bytsura/\" target=\"_blank\">Guide to titling finding aids</a>") }
    end

    context "when document is a series level item" do
      let(:ref_ssi) { "1234" }
      let(:format_ssm) { "Archival Series" }

      it { should eql("<a href=\"http://dlib.nyu.edu/findingaids/html/fales/bytsura/dsc1234.html\" target=\"_blank\">Guide to titling finding aids</a>") }
    end

    context "when document is item level" do
      let(:ref_ssi) { "5678" }
      let(:parent_ssm) { ["1234"] }
      let(:format_ssm) { "Archival Item" }

      it { should eql("<a href=\"http://dlib.nyu.edu/findingaids/html/fales/bytsura/dsc1234.html#5678\" target=\"_blank\">Guide to titling finding aids</a>") }
    end

  end

end
