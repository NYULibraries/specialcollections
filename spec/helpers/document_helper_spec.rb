require "spec_helper"

describe DocumentHelper do
  
  include BlacklightHelper
  include ApplicationHelper
  include DocumentHelper
  include ActionView::Helpers::UrlHelper
  
  let(:repositories) do
    {"fales" => {"display" => "The Fales Library"}}
  end
  let(:title_ssm) { "The Title" }
  let(:field) { :title_ssm }
  let(:ref_ssi) { nil }
  let(:parent_ssm) { nil }
  let(:format_ssm) { "Archival Collection" }
  let(:heading_ssm) { ["Guide to titling finding aids"] }
  let(:ead_ssi) { "bytsura" }
  let(:highlight_field) { ead_ssi }
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
        :heading_ssm => heading_ssm
      }, solr_response), 
      :field => field
    }.with_indifferent_access
  end
  let(:blacklight_config) do
    @config ||= Blacklight::Configuration.new.configure do |config|
      config.index.show_link = "heading_ssm"
      config.index.record_display_type = "format_ssm"

      config.show.html_title = "heading_ssm"
      config.show.heading = "heading_ssm"
      config.show.display_type = "format_ssm"
    end
  end
  let(:source_params) do
    {
      :action => "index",
      :controller => "catalog",
      :id => "bytsura123",
      :commit => "true",
      :utf8 => "checky"
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
  
  describe ".link_to_document" do

    subject { link_to_document(collection) }
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
  
  describe ".sort_by_series" do
    
    let(:default_sort_hash) {{:sort => "series_si asc, box_filing_si asc"}}
    
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
    let(:collection) { document[:document] }
    subject { link_to_repository(collection)}
    context "when document is a collection level item" do
      it { should eql("<a href=\"/fales\">The Fales Library</a>") }
    end
    
  end
  
  describe ".repository_label" do
    subject { repository_label(document[:document]) }
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
    let(:local_params) do
      source_params.merge({
        :leftover => "Yup",
        :smorgas => nil
      })
    end
    subject { sanitize_search_params(local_params) }
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
  
end