require "spec_helper"

describe ResultsHelper do

  include ApplicationHelper
  include BlacklightHelper
  include ActionView::Helpers::UrlHelper

  let(:repositories) {{"fales" => {"display" => "The Fales Library"}}}
  let(:heading) { "Guide to titling finding aids" }
  let(:params) {{:controller => "catalog", :action => "index"}}
  let(:default_sort_hash) { {} }
  let(:field) { "unittitle_ssm" }
  let(:solr_document) { create(:solr_document) }
  let(:document) {{ document: solr_document, field: field }}
  let(:blacklight_config) { create(:blacklight_config) }
  let(:source_params) do
    ActionController::Parameters.new({
      :action => "index",
      :controller => "catalog",
      :id => "bytsura123",
      :commit => "true",
      :utf8 => "checky",
      :leftover => "Yup",
      :smorgas => nil
    })
  end

  describe "#render_field_item" do
    subject { render_field_item(document) }
    context "when the title is plain text" do
      it { should eql("The Title") }
    end
    context "when the title has html" do
      let(:solr_document) { create(:solr_document, unittitle: ["<b>The Title</b>"]) }
      it { should be_html_safe }
      it { should eql("<b>The Title</b>") }
    end
    context "when the there are more than 450 characters in a field" do
       let(:solr_document) { create(:solr_document, unittitle: ["Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu ped"]) }
       it { should eql "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis e..."}
    end
  end

  describe "#document_icon" do
    subject { document_icon(document[:document]) }
    context "when document is a collection level item" do
      it { should eql("archival_collection") }
    end
    context "when document is a series level item" do
      let(:solr_document) { create(:solr_document, format: ["Archival Series"]) }
      it { should eql("archival_series") }
    end
    context "when document is item level" do
      let(:solr_document) { create(:solr_document, format: ["Archival Object"]) }
      it { should eql("archival_object") }
    end
  end

  describe "#link_to_repository" do
    let(:collection) { "fales" }
    subject { link_to_repository(collection)}
    context "when document is a collection level item" do
      it { should eql("<a href=\"/fales\">The Fales Library</a>") }
    end
  end

  describe "#repository_label" do
    subject { repository_label(document[:document][:repository_ssi]) }
    it { should eq("The Fales Library") }
  end

  describe "#facet_name" do
    it "should return the Solrized name of the facet" do
      expect(facet_name("test")).to eql("test_sim")
    end
  end

  describe "#collection_facet" do
    it "should alias facet_name function for collection facet" do
      expect(collection_facet).to eql("collection_sim")
    end
  end

  describe "#format_facet" do
    it "should alias facet_name function for format facet" do
      expect(format_facet).to eql("format_sim")
    end
  end

  describe "#series_facet" do
    it "should alias facet_name for series facet" do
      expect(series_facet).to eql("series_sim")
    end
  end

  describe "#reset_facet_params" do
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
    it { should eql({"leftover" => "Yup", "q" => "ephemera"}) }
  end

  describe "#render_collection_facet_link" do
    subject { render_collection_facet_link(document) }
    context "when document is a collection level item" do
      let(:field) { :collection_ssm }
      it { should eql "<a class=\"search_within\" href=\"/catalog?f%5Bcollection_sim%5D%5B%5D=Bytsura+Collection+of+Things\">Search all archival materials within this collection</a>" }
    end
    context "when document is a series level item" do
      let(:solr_document) { create(:solr_document, format: ["Archival Series"]) }
      it { should eql("<span class=\"search_within\">To request this item, please note the following information</span>") }
    end
  end

  describe "#render_contained_in_links" do
    let(:field) { :heading_ssm }
    let(:solr_document) { create(:solr_document, parent_unittitles: ["Series I", "Subseries IV"]) }
    subject { render_contained_in_links(document) }
    it { should eql "<a href=\"/catalog?f%5Bcollection_sim%5D%5B%5D=Bytsura+Collection+of+Things\">Bytsura Collection of Things</a> >> <a href=\"/catalog?f%5Bcollection_sim%5D%5B%5D=Bytsura+Collection+of+Things&amp;f%5Bseries_sim%5D%5B%5D=Series+I\">Series I</a> >> <a href=\"/catalog?f%5Bcollection_sim%5D%5B%5D=Bytsura+Collection+of+Things&amp;f%5Bseries_sim%5D%5B%5D=Subseries+IV\">Subseries IV</a> >> <span class=\"unittitle\">The Title</span>" }
    it { expect(sanitize_html(subject)).to eql("Bytsura Collection of Things >> Series I >> Subseries IV >> The Title") }
  end

  describe "#render_repository_facet_link" do
    let(:repositories) {{"fales" => {"display" => "The Fales Library", "admin_code" => "fales", "url" => "fales"}}}
    subject { render_repository_facet_link(document[:document][:repository_ssi]) }
    it { should eql "The Fales Library" }
  end

  describe "#render_repository_link" do
    let(:repositories) {{"fales" => {"display" => "The Fales Library", "admin_code" => "fales", "url" => "fales"}}}
    subject { render_repository_link(document) }
    it { should eql "<a href=\"/fales\">The Fales Library</a>" }
    it { expect(sanitize_html(subject)).to eql("The Fales Library") }
  end

  describe "#link_to_document" do
    subject { link_to_document(collection, heading) }
    let(:collection) { document[:document] }
    context "when document is not a real url" do
      context "and document is a collection level item" do
        it { should eql("<a href=\"http://dlib.nyu.edu/findingaids/html/fales/testead/dsc.html#123\" target=\"_blank\">Guide to titling finding aids</a>") }
      end
      context "and document is a series level item" do
        let(:solr_document) { create(:solr_document, format: ["Archival Series"], parent: ["ref344"], ref: "ref350") }
        it { should eql("<a href=\"http://dlib.nyu.edu/findingaids/html/fales/testead/dsc.html#ref350\" target=\"_blank\">Guide to titling finding aids</a>") }
      end
      context "and document is an object level item" do
        let(:solr_document) { create(:solr_document, format: ["Archival Object"], parent: ["ref3"], ref: "ref309") }
        it { should eql("<a href=\"http://dlib.nyu.edu/findingaids/html/fales/testead/dsc.html#ref309\" target=\"_blank\">Guide to titling finding aids</a>") }
      end
    end
    context "when document is a real url" do
      context "and document is an collection level item" do
        let(:solr_document) { create(:solr_document, format: ["Archival Collection"], id: "bytsura", ead: "bytsura") }
        it { should eql("<a href=\"http://dlib.nyu.edu/findingaids/html/fales/bytsura/\" target=\"_blank\">Guide to titling finding aids</a>") }
      end
      context "and document is an series level item" do
        let(:solr_document) { create(:solr_document, format: ["Archival Series"], id: "bytsura", ead: "bytsura", parent: nil, ref: "ref3") }
        it { should eql("<a href=\"http://dlib.nyu.edu/findingaids/html/fales/bytsura/dscref3.html\" target=\"_blank\">Guide to titling finding aids</a>") }
      end
      context "and document is an object level item" do
        let(:solr_document) { create(:solr_document, format: ["Archival Object"], id: "bytsura", ead: "bytsura", parent: ["ref3"], ref: "ref309") }
        it { should eql("<a href=\"http://dlib.nyu.edu/findingaids/html/fales/bytsura/dscref3.html#ref309\" target=\"_blank\">Guide to titling finding aids</a>") }
      end
    end
  end

  describe "#is_collection?" do
    subject { is_collection?({}, document[:document]) }
    context "when document is a collection" do
      it { should be_true }
    end
    context "when document is a component" do
      let(:solr_document) { create(:solr_document, format: ["Archival Object"]) }
      it { should be_false }
    end
  end

  describe "#link_to_collection" do
    subject { link_to_collection("The Collection") }
    it { should eql "<a href=\"/catalog?f%5Bcollection_sim%5D%5B%5D=The+Collection\">The Collection</a>" }
  end

  describe "#links_to_series" do
    subject { links_to_series(["Series I", "Series II"], "The Collection").join(" >> ") }
    it { should eql "<a href=\"/catalog?f%5Bcollection_sim%5D%5B%5D=The+Collection&amp;f%5Bseries_sim%5D%5B%5D=Series+I\">Series I</a> >> <a href=\"/catalog?f%5Bcollection_sim%5D%5B%5D=The+Collection&amp;f%5Bseries_sim%5D%5B%5D=Series+II\">Series II</a>" }
  end

  describe "#sanitize_html" do
    let(:html_to_sanitize) { "<strong>Whassup</strong>" }
    subject { sanitize_html(html_to_sanitize) }
    context "when the string contains accepted html" do
      it { should eql "<strong>Whassup</strong>" }
    end
    context "when the string contains unaccepted html" do
      let(:html_to_sanitize) { "<iframe>Whassup</iframe>" }
      it { should eql "Whassup" }
    end
  end


end
