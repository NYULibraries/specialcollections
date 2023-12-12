require 'rails_helper'

describe ResultsHelper do

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
    subject { helper.render_field_item(document) }
    context "when the title is plain text" do
      it { is_expected.to eql("The Title") }
    end
    context "when the title has html" do
      let(:solr_document) { create(:solr_document, unittitle: ["<b>The Title</b>"]) }
      it { is_expected.to be_html_safe }
      it { is_expected.to eql("<b>The Title</b>") }
    end
    context "when the there are more than 450 characters in a field" do
       let(:solr_document) { create(:solr_document, unittitle: ["Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu ped"]) }
       it { is_expected.to eql "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis e..."}
    end
  end

  describe "#document_icon" do
    subject { helper.document_icon(document[:document]) }
    context "when document is a collection level item" do
      it { is_expected.to eql("archival_collection") }
    end
    context "when document is a series level item" do
      let(:solr_document) { create(:solr_document, format: ["Archival Series"]) }
      it { is_expected.to eql("archival_series") }
    end
    context "when document is item level" do
      let(:solr_document) { create(:solr_document, format: ["Archival Object"]) }
      it { is_expected.to eql("archival_object") }
    end
  end

  describe "#link_to_repository" do
    let(:collection) { "fales" }
    subject { helper.link_to_repository(collection)}
    before { allow(helper).to receive(:repositories).and_return repositories }
    context "when document is a collection level item" do
      it { is_expected.to eql("<a href=\"/fales\">The Fales Library</a>") }
    end
  end

  describe "#repository_label" do
    subject { helper.repository_label(document[:document][:repository_ssi]) }
    before { allow(helper).to receive(:repositories).and_return repositories }
    it { is_expected.to eq("The Fales Library") }
  end

  describe "#facet_name" do
    it "is_expected.to return the Solrized name of the facet" do
      expect(helper.facet_name("test")).to eql("test_sim")
    end
  end

  describe "#collection_facet" do
    it "is_expected.to alias facet_name function for collection facet" do
      expect(helper.collection_facet).to eql("collection_sim")
    end
  end

  describe "#format_facet" do
    it "is_expected.to alias facet_name function for format facet" do
      expect(helper.format_facet).to eql("format_sim")
    end
  end

  describe "#series_facet" do
    it "is_expected.to alias facet_name for series facet" do
      expect(helper.series_facet).to eql("series_sim")
    end
  end

  describe "#reset_facet_params" do
    subject { helper.reset_facet_params(local_params) } #.permit(:q, :leftover).to_h }
    let(:local_params) do
      source_params.merge({
        :leftover => "Yup",
        :smorgas => nil,
        :page => 1,
        :counter => 10,
        :q => "ephemera",
        :f => {:repository_sim => ["fales"]}
      })
    end
    before { allow(helper).to receive(:blacklight_config).and_return blacklight_config }
    its(:keys) { is_expected.to match_array %w[q leftover] }
    it "should preserve values" do
      expect(subject.permit(:q)[:q]).to eq "ephemera"
      expect(subject.permit(:leftover)[:leftover]).to eq "Yup"
    end
  end

  describe "#render_parent_facet_link" do
    subject { helper.render_parent_facet_link(document) }
    before { allow(helper).to receive(:blacklight_config).and_return blacklight_config }
    context "when document is a collection level item" do
      let(:field) {:collection_ssm}
      it { is_expected.to eql "<a class=\"search_within\" href=\"/?f%5Bcollection_sim%5D%5B%5D=Bytsura+Collection+of+Things\">Search all archival materials within this collection</a>" }
      context "when document title is nil" do
        let(:solr_document) { create(:solr_document, unittitle: []) }
        it { is_expected.to eql nil }
      end
    end
    context "when document is a series level item" do
      let(:field) {:collection_ssm}
      let(:solr_document) { create(:solr_document, format: ["Archival Series"], unittitle: ["Series I"] ) }
      it { is_expected.to eql "<a class=\"search_within\" href=\"/?f%5Bcollection_sim%5D%5B%5D=Bytsura+Collection+of+Things&amp;f%5Bseries_sim%5D%5B%5D=Series+I\">Search all archival materials within this series</a>" }
      context "when document title is nil" do
        let(:solr_document) { create(:solr_document, format: ["Archival Series"], unittitle: []) }
        it { is_expected.to eql "<span class=\"search_within\">Series doesn&#39;t have unittitle you can&#39;t search within it</span>" }
      end
    end
    context "when document is an object level item" do
      let(:solr_document) { create(:solr_document, format: ["Archival Object"]) }
      it { is_expected.to eql "<span class=\"search_within\">To request this item, please note the following information</span>" }
    end
  end

  describe "#render_search_within_collection_instructions" do
    subject { helper.render_search_within_collection_instructions(document) }
    let(:field) {:collection_ssm}
    before { allow(helper).to receive(:blacklight_config).and_return blacklight_config }
    context "when collection has title" do
      it { is_expected.to eql "<a class=\"search_within\" href=\"/?f%5Bcollection_sim%5D%5B%5D=Bytsura+Collection+of+Things\">Search all archival materials within this collection</a>" }
    end
    context "when collection doesn't have title" do
      let(:solr_document) { create(:solr_document, unittitle: []) }
      it { is_expected.to eql nil }
    end
  end

  describe "#render_search_within_series_instructions" do
    subject { helper.render_search_within_series_instructions(document) }
    let(:field) {:collection_ssm}
    before { allow(helper).to receive(:blacklight_config).and_return blacklight_config }
    context "when series has title" do
      let(:solr_document) { create(:solr_document, format: ["Archival Series"], unittitle: ["Series I"] ) }
      it { is_expected.to eql "<a class=\"search_within\" href=\"/?f%5Bcollection_sim%5D%5B%5D=Bytsura+Collection+of+Things&amp;f%5Bseries_sim%5D%5B%5D=Series+I\">Search all archival materials within this series</a>" }
    end
    context "when series doesn't have title" do
      let(:solr_document) { create(:solr_document, format: ["Archival Series"], unittitle: []) }
      it { is_expected.to eql "<span class=\"search_within\">Series doesn&#39;t have unittitle you can&#39;t search within it</span>" }
    end
  end


  describe "#render_collection_facet_link" do
    subject { helper.render_collection_facet_link(document) }
    let(:field) {:collection_ssm}
    before { allow(helper).to receive(:blacklight_config).and_return blacklight_config }
    it { is_expected.to eql "<a class=\"search_within\" href=\"/?f%5Bcollection_sim%5D%5B%5D=Bytsura+Collection+of+Things\">Search all archival materials within this collection</a>" }
  end

  describe "#render_series_facet_link" do
    subject { helper.render_series_facet_link(document) }
    let(:field) {:collection_ssm}
    let(:solr_document) { create(:solr_document, format: ["Archival Series"], unittitle: ["Series I"] ) }
    before { allow(helper).to receive(:blacklight_config).and_return blacklight_config }
    it { is_expected.to eql "<a class=\"search_within\" href=\"/?f%5Bcollection_sim%5D%5B%5D=Bytsura+Collection+of+Things&amp;f%5Bseries_sim%5D%5B%5D=Series+I\">Search all archival materials within this series</a>" }
  end

  describe "#render_request_item_istructions" do
    subject { helper.render_request_item_istructions }
    before { allow(helper).to receive(:blacklight_config).and_return blacklight_config }
    it { is_expected.to eql "<span class=\"search_within\">To request this item, please note the following information</span>" }
  end

  describe "#render_contained_in_links" do
    subject { helper.render_contained_in_links(document) }
    let(:field) { :heading_ssm }
    let(:solr_document) { create(:solr_document, parent_unittitles: ["Series I", "Subseries IV"]) }
    before { allow(helper).to receive(:blacklight_config).and_return blacklight_config }
    it { is_expected.to eql "<a href=\"/?f%5Bcollection_sim%5D%5B%5D=Bytsura+Collection+of+Things\">Bytsura Collection of Things</a> >> <a href=\"/?f%5Bcollection_sim%5D%5B%5D=Bytsura+Collection+of+Things&amp;f%5Bseries_sim%5D%5B%5D=Series+I\">Series I</a> >> <a href=\"/?f%5Bcollection_sim%5D%5B%5D=Bytsura+Collection+of+Things&amp;f%5Bseries_sim%5D%5B%5D=Subseries+IV\">Subseries IV</a> >> <span class=\"unittitle\">The Title</span>" }
    it { expect(sanitize_html(subject)).to eql("Bytsura Collection of Things &gt;&gt; Series I &gt;&gt; Subseries IV &gt;&gt; The Title") }
  end

  describe "#render_repository_facet_link" do
    subject { helper.render_repository_facet_link(document[:document][:repository_ssi]) }
    let(:repositories) {{"fales" => {"display" => "The Fales Library", "admin_code" => "fales", "url" => "fales"}}}
    before { allow(helper).to receive(:repositories).and_return repositories }
    it { is_expected.to eql "The Fales Library" }
  end

  describe "#render_repository_link" do
    subject { helper.render_repository_link(document) }
    let(:repositories) {{"fales" => {"display" => "The Fales Library", "admin_code" => "fales", "url" => "fales"}}}
    before { allow(helper).to receive(:repositories).and_return repositories }
    it { is_expected.to eql "<a href=\"/fales\">The Fales Library</a>" }
    it { expect(sanitize_html(subject)).to eql("The Fales Library") }
  end

  describe "#link_to_document" do
    subject { helper.link_to_document(collection, heading) }
    let(:collection) { document[:document] }
    before { allow(helper).to receive(:blacklight_config).and_return blacklight_config }
    context "when in the legacy configuration" do
      before { ENV['FINDINGAIDS_2022_MIGRATION'] = nil }
      context "when document is not a real url" do
        context "and document is a collection level item" do
          it { is_expected.to eql("<a target=\"_blank\" href=\"http://dlib.nyu.edu/findingaids/html/fales/testead/dsc.html#123\">Guide to titling finding aids</a>") }
        end
        context "and document is a series level item" do
          let(:solr_document) { create(:solr_document, format: ["Archival Series"], parent: ["ref344"], ref: "ref350") }
          it { is_expected.to eql("<a target=\"_blank\" href=\"http://dlib.nyu.edu/findingaids/html/fales/testead/dsc.html#ref350\">Guide to titling finding aids</a>") }
        end
        context "and document is an object level item" do
          let(:solr_document) { create(:solr_document, format: ["Archival Object"], parent: ["ref3"], ref: "ref309") }
          it { is_expected.to eql("<a target=\"_blank\" href=\"http://dlib.nyu.edu/findingaids/html/fales/testead/dsc.html#ref309\">Guide to titling finding aids</a>") }
        end
      end
      # NOTE: broken since urls no longer resolve correctly
      #context "when document is a real url" do
      #  context "and document is an collection level item" do
      #    let(:solr_document) { create(:solr_document, format: ["Archival Collection"], id: "mss_313", ead: "mss_313") }
      #    it { is_expected.to eql("<a target=\"_blank\" href=\"http://dlib.nyu.edu/findingaids/html/fales/mss_313/\">Guide to titling finding aids</a>") }
      #  end
      #  context "and document is an series level item" do
      #    let(:solr_document) { create(:solr_document, format: ["Archival Series"], id: "mss_313", ead: "mss_313", parent: nil, ref: "aspace_ref3") }
      #    it { is_expected.to eql("<a target=\"_blank\" href=\"http://dlib.nyu.edu/findingaids/html/fales/mss_313/dscaspace_ref3.html\">Guide to titling finding aids</a>") }
      #  end
      #  context "and document is an object level item" do
      #    let(:solr_document) { create(:solr_document, format: ["Archival Object"], id: "mss_313", ead: "mss_313", parent: ["aspace_ref3"], ref: "aspace_ref309") }
      #    it { is_expected.to eql("<a target=\"_blank\" href=\"http://dlib.nyu.edu/findingaids/html/fales/mss_313/dscaspace_ref3.html#aspace_ref309\">Guide to titling finding aids</a>") }
      #  end
      #end
    end
    context "when in the FINDINGAIDS_2022_MIGRATION configuration" do
      before {
        ENV['FINDINGAIDS_2022_MIGRATION'] = "1"
      }
      after {
        ENV['FINDINGAIDS_2022_MIGRATION'] = nil
      }
      context "when document is not a real url" do
        context "and document is a collection level item" do
          it { is_expected.to eql("<a target=\"_blank\" href=\"https://findingaids.library.nyu.edu/fales/testead/all/#123\">Guide to titling finding aids</a>") }
        end
        context "and document is a series level item" do
          let(:solr_document) { create(:solr_document, format: ["Archival Series"], parent: ["ref344"], ref: "ref350") }
          it { is_expected.to eql("<a target=\"_blank\" href=\"https://findingaids.library.nyu.edu/fales/testead/all/#ref350\">Guide to titling finding aids</a>") }
        end
        context "and document is an object level item" do
          let(:solr_document) { create(:solr_document, format: ["Archival Object"], parent: ["ref3"], ref: "ref309") }
          it { is_expected.to eql("<a target=\"_blank\" href=\"https://findingaids.library.nyu.edu/fales/testead/all/#ref309\">Guide to titling finding aids</a>") }
        end
      end
      context "when document is a real url" do
        before {
          # https://stackoverflow.com/a/66783988
          allow_any_instance_of(Faraday::Connection).to receive(:head).and_return(double(Faraday::Response, status: 200))
        }
        after {
          # https://makandracards.com/makandra/480226-how-to-reset-a-mock
          RSpec::Mocks.space.proxy_for(Faraday::Connection).reset
        }
        context "and document is an collection level item" do
          let(:solr_document) { create(:solr_document, format: ["Archival Collection"], id: "mss_313", ead: "mss_313") }
          it { is_expected.to eql("<a target=\"_blank\" href=\"https://findingaids.library.nyu.edu/fales/mss_313/\">Guide to titling finding aids</a>") }
        end
        context "and document is an series level item" do
          let(:solr_document) { create(:solr_document, format: ["Archival Series"], id: "mss_313", ead: "mss_313", parent: nil, ref: "aspace_ref3") }
          it { is_expected.to eql("<a target=\"_blank\" href=\"https://findingaids.library.nyu.edu/fales/mss_313/contents/aspace_ref3/\">Guide to titling finding aids</a>") }
        end
        context "and document is an object level item" do
          let(:solr_document) { create(:solr_document, format: ["Archival Object"], id: "mss_313", ead: "mss_313", parent: ["aspace_ref3"], ref: "aspace_ref309") }
          it { is_expected.to eql("<a target=\"_blank\" href=\"https://findingaids.library.nyu.edu/fales/mss_313/contents/aspace_ref3/#aspace_ref309\">Guide to titling finding aids</a>") }
        end
      end
    end
  end

  describe "#is_collection?" do
    subject { helper.is_collection?({}, document[:document]) }
    context "when document is a collection" do
      it { is_expected.to be true }
    end
    context "when document is a component" do
      let(:solr_document) { create(:solr_document, format: ["Archival Object"]) }
      it { is_expected.to be false }
    end
  end

   describe "#is_series?" do
    subject { helper.is_series?({}, document[:document]) }
    context "when document is collection" do
      it { is_expected.to be false }
    end
    context "when document is an archival object" do
      let(:solr_document) { create(:solr_document, format: ["Archival Object"]) }
      it { is_expected.to be false }
    end
    context "when document is a series" do
      let(:solr_document) { create(:solr_document, format: ["Archival Series"]) }
      it { is_expected.to be true }
    end
  end

  describe "#link_to_collection" do
    subject { helper.link_to_collection("The Collection") }
    before { allow(helper).to receive(:blacklight_config).and_return blacklight_config }
    it { is_expected.to eql "<a href=\"/?f%5Bcollection_sim%5D%5B%5D=The+Collection\">The Collection</a>" }
  end

  describe "#links_to_series" do
    subject { helper.links_to_series(["Series I", "Series II"], "The Collection").join(" >> ") }
    before { allow(helper).to receive(:blacklight_config).and_return blacklight_config }
    it { is_expected.to eql "<a href=\"/?f%5Bcollection_sim%5D%5B%5D=The+Collection&amp;f%5Bseries_sim%5D%5B%5D=Series+I\">Series I</a> >> <a href=\"/?f%5Bcollection_sim%5D%5B%5D=The+Collection&amp;f%5Bseries_sim%5D%5B%5D=Series+II\">Series II</a>" }
  end

  describe "#sanitize_html" do
    let(:html_to_sanitize) { "<strong>Whassup</strong>" }
    subject { helper.sanitize_html(html_to_sanitize) }
    context "when the string contains accepted html" do
      it { is_expected.to eql "<strong>Whassup</strong>" }
    end
    context "when the string contains unaccepted html" do
      let(:html_to_sanitize) { "<iframe>Whassup</iframe>" }
      it { is_expected.to eql "Whassup" }
    end
  end

end
