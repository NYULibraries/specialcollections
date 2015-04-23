require 'spec_helper'

describe SolrDocument do

  let(:format_ssm) { "Archival Collection" }
  let(:unittitle_ssm) { "The Unit Title" }
  let(:parent_unittitles_ssm) { ["Series I", "Series II"] }
  let(:unitdate_ssm) { "Inclusive: 91-95 ; Bulk: April 95" }
  let(:repository_ssm) { "The Fales Library" }
  let(:location_ssm) { "Box 12, Folder 99" }
  let(:collection_ssm) { "The Papers of Bartholomew Jenkins" }
  let(:document) do
    SolrDocument.new({
      :unittitle_ssm => [unittitle_ssm],
      :parent_unittitles_ssm => parent_unittitles_ssm,
      :format_ssm => [format_ssm],
      :unitdate_ssm => [unitdate_ssm],
      :repository_ssm => [repository_ssm],
      :location_ssm => [location_ssm],
      :collection_ssm => [collection_ssm]
    })
  end

  describe "#normalized_format" do
    subject { document.normalized_format }

    context "when document is a collection level item" do
      it { should eql("archival_collection") }
    end

    context "when document is a series level item" do
      let(:format_ssm) { "Archival Series" }
      it { should eql("archival_series") }
    end

    context "when document is an item" do
      let(:format_ssm) { "Archival Object" }
      it { should eql("archival_object") }
    end

  end

  describe "#export_as_ead_citation_txt" do
    subject { document.export_as_ead_citation_txt }
    it { should eql "<strong>The Unit Title</strong>; Inclusive: 91-95 ; Bulk: April 95; The Papers of Bartholomew Jenkins; Box 12; Folder 99; The Fales Library" }
  end

  describe "#method_missing" do
    context "when there is no matcher" do
      it { expect{ document.eats_cheese? }.to raise_error(NoMethodError) }
    end

    describe "#is_archival_collection?" do
      subject { document.is_archival_collection? }
      context "when document is a collection level item" do
        it { should be_true }
        it { expect(document.is_archival_series?).to be_false }
        it { expect(document.is_archival_object?).to be_false }
      end
      context "when document is a series level item" do
        let(:format_ssm) { "Archival Series" }
        it { should be_false }
      end
    end

    describe "#is_archival_series?" do
      context "when document is a series level item" do
        let(:format_ssm) { "Archival Series" }
        subject { document.is_archival_series? }
        it { should be_true }
        it { expect(document.is_archival_collection?).to be_false }
        it { expect(document.is_archival_object?).to be_false }
      end
    end

    describe "#is_archival_object?" do
      context "when document is an item" do
        let(:format_ssm) { "Archival Object" }
        subject { document.is_archival_object? }
        it { should be_true }
        it { expect(document.is_archival_collection?).to be_false }
        it { expect(document.is_archival_series?).to be_false }
      end
    end

    describe "#parent_unittitles" do
      subject { document.parent_unittitles }
      it { should eql ["Series I", "Series II"] }
    end

    describe "#unittitle" do
      subject { document.unittitle }
      it { should eql "The Unit Title" }
    end

  end

end
