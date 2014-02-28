require "spec_helper"

describe DocumentHelper do
  
  include BlacklightHelper
  include ApplicationHelper
  include DocumentHelper
  include ActionView::Helpers::UrlHelper
  
  def blacklight_config
    @config ||= Blacklight::Configuration.new.configure do |config|
      config.index.show_link = "heading_ssm"
      config.index.record_display_type = "format_ssm"

      config.show.html_title = "heading_ssm"
      config.show.heading = "heading_ssm"
      config.show.display_type = "format_ssm"
    end
  end
  
  before :all do
    @collection = {
      :document => SolrDocument.new({
        :format_ssm => ["Archival Collection"],
        :title_ssm => ["The Title"],
        :abstract_ssm => ["The Abstract"],
        :repository_ssi => "fales",
        :ead_ssi => "bytsura",
        :bioghist_ssm => ["Biographical something something"],
        :custodhist_ssm => ["This field contains info"]
      }), 
      :field => :title_ssm
    }.with_indifferent_access
    
    @series = {
      :document => SolrDocument.new({
        :format_ssm => ["Archival Series"],
        :title_ssm => ["The Title"],
        :abstract_ssm => ["The Abstract"],
        :repository_ssi => "fales",
        :ead_ssi => "bytsura",
        :bioghist_ssm => ["Biographical something something"],
        :custodhist_ssm => ["This field contains info"],
        :ref_ssi => "1234"
      }), 
      :field => :title_ssm
    }.with_indifferent_access
    
    @item = {
      :document => SolrDocument.new({
        :format_ssm => ["Archival Item"],
        :title_ssm => ["The Title"],
        :abstract_ssm => ["The Abstract"],
        :repository_ssi => "fales",
        :ead_ssi => "bytsura",
        :bioghist_ssm => ["Biographical something something"],
        :custodhist_ssm => ["This field contains info"],
        :ref_ssi => "5678",
        :parent_ssm => ["1234"]
      }), 
      :field => :title_ssm
    }.with_indifferent_access
  end
  
  describe ".render_field_name" do
    it "should return the field value" do
      render_field_item(@collection).should eql("The Title")
    end
    it "should return an html_safe response" do
      @collection = @collection.merge({:document => {:title_ssm => ["<b>The Title</b>"]}})
      render_field_item(@collection).should.html_safe? == true
      render_field_item(@collection).should eql("<b>The Title</b>")
    end
  end
  
  describe ".link_to_toc_page" do
    
    it "should render a <dd> tag with a link to index page" do
      doc = @collection[:document]
      link_to_toc_page(doc, "Click Here", "abstract").should eql("<dd><a href=\"http://dlib.nyu.edu/findingaids/html/fales/bytsura/\" target=\"_blank\">Click Here</a></dd>")
    end
    
    it "should render a <dd> tag with a link to bioghist page" do
      doc = @collection[:document]
      link_to_toc_page(doc, "Click Here", "bioghist").should eql("<dd><a href=\"http://dlib.nyu.edu/findingaids/html/fales/bytsura/bioghist.html\" target=\"_blank\">Click Here</a></dd>")
    end
    
    it "should render a <dd> tag with a link to admininfo page" do
      doc = @collection[:document]
      link_to_toc_page(doc, "Click Here", "admininfo").should eql("<dd><a href=\"http://dlib.nyu.edu/findingaids/html/fales/bytsura/admininfo.html\" target=\"_blank\">Click Here</a></dd>")
    end
    
    it "should not render a link because there are no results for field" do
      doc = @collection[:document]
      link_to_toc_page(doc, "Click Here", "dsc").should be_nil
    end
    
  end
  
  describe ".link_to_document" do
    
    it "should render a link to archival collection document" do
      doc = @collection[:document]
      link_to_document(doc).should eql("<a href=\"http://dlib.nyu.edu/findingaids/html/fales/bytsura/\" target=\"_blank\"></a>")
    end
    
    it "should render a link to archival series document" do
      doc = @series[:document]
      link_to_document(doc).should eql("<a href=\"http://dlib.nyu.edu/findingaids/html/fales/bytsura/dsc1234.html\" target=\"_blank\"></a>")
    end
    
    it "should render a link to archival item document" do
      doc = @item[:document]
      link_to_document(doc).should eql("<a href=\"http://dlib.nyu.edu/findingaids/html/fales/bytsura/dsc1234.html#5678\" target=\"_blank\"></a>")
    end
    
  end

end