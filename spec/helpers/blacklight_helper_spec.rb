require "spec_helper"

describe BlacklightHelper do

  include ApplicationHelper
  include Blacklight::BlacklightHelperBehavior

  let(:field) { "unittitle_ssm" }
  let(:solr_document) { create(:solr_document) }
  let(:blacklight_config) { create(:blacklight_config) }
  let(:document) {{ document: solr_document, field: field }}

  describe "#link_to_document" do
    let(:opts) { {:counter => nil} }
    subject { link_to_document(document[:document],document[:document][:field],opts)}
    context "when document has title" do
      it { should eql("<a target=\"_blank\" href=\"http://dlib.nyu.edu/findingaids/html/fales/testead/dsc.html#123\">Guide to titling finding aids</a>") }
    end
    context "when document doesn't have title" do
      let(:solr_document) { create(:solr_document, unittitle: []) }
      it { should eql( "<a target=\"_blank\" href=\"http://dlib.nyu.edu/findingaids/html/fales/testead/dsc.html#123\">No Title</a>") }
    end
  end
end
