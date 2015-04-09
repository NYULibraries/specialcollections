require "spec_helper"

describe CitationHelper do

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

  describe "#render_citation_field" do
    let(:solr_document) { create(:solr_document, unittitle: ["The Title"]) }
    subject { render_citation_field(document[:document]) }
    context "citation is present" do
      it { should eql("The Title, Bytsura Collection of Things; fales") }
    end
   
  end

  
end
