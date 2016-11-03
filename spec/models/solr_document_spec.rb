require 'rails_helper'

describe SolrDocument do

  let(:format_ssm) { "Archival Collection" }
  let(:unittitle_ssm) { "The Unit Title" }
  let(:parent_unittitles_ssm) { ["Series I", "Series II"] }
  let(:unitdate_ssm) { "Inclusive: 91-95 ; Bulk: April 95" }
  let(:repository_ssm) { "fales" }
  let(:location_ssm) { "Box 12, Folder 99" }
  let(:collection_ssm) { "The Papers of Bartholomew Jenkins" }
  let(:unitid_ssm) { "MSS 122" }
  let(:document) do
    SolrDocument.new({
      :unittitle_ssm => [unittitle_ssm],
      :parent_unittitles_ssm => parent_unittitles_ssm,
      :format_ssm => [format_ssm],
      :unitdate_ssm => [unitdate_ssm],
      :repository_ssm => [repository_ssm],
      :location_ssm => [location_ssm],
      :collection_ssm => [collection_ssm],
      :unitid_ssm => [unitid_ssm]
    })
  end

  describe "#normalized_format" do
    subject { document.normalized_format }

    context "when document is a collection level item" do
      it { is_expected.to eql("archival_collection") }
    end

    context "when document is a series level item" do
      let(:format_ssm) { "Archival Series" }
      it { is_expected.to eql("archival_series") }
    end

    context "when document is an item" do
      let(:format_ssm) { "Archival Object" }
      it { is_expected.to eql("archival_object") }
    end

  end

  describe "#export_as_ead_citation_txt" do
    subject { document.export_as_ead_citation_txt }
    it { is_expected.to eql "<strong>The Unit Title</strong>, Inclusive: 91-95 ; Bulk: April 95; MSS 122; Box 12; Folder 99; The Fales Library & Special Collections" }
  end

  describe "#method_missing" do
    context "when there is no matcher" do
      it 'should throw a no method erro' do
        expect{ document.eats_cheese? }.to raise_error(NoMethodError)
      end
    end

    describe "#is_archival_collection?" do
      subject { document.is_archival_collection? }
      context "when document is a collection level item" do
        it { is_expected.to be true }
        it 'should not also identify as an archival series' do
          expect(document.is_archival_series?).to be false
        end
        it 'should not also identify as an archival object' do
          expect(document.is_archival_object?).to be false
        end
      end
      context "when document is a series level item" do
        let(:format_ssm) { "Archival Series" }
        it { is_expected.to be false }
      end
    end

    describe "#is_archival_series?" do
      context "when document is a series level item" do
        let(:format_ssm) { "Archival Series" }
        subject { document.is_archival_series? }
        it { is_expected.to be true }
        it 'should not also identify as an archival collection' do
          expect(document.is_archival_collection?).to be false
        end
        it 'should not also identify as an archival object' do
          expect(document.is_archival_object?).to be false
        end
      end
    end

    describe "#is_archival_object?" do
      context "when document is an item" do
        let(:format_ssm) { "Archival Object" }
        subject { document.is_archival_object? }
        it { is_expected.to be true }
        it 'should not also identify as an archival collection' do
          expect(document.is_archival_collection?).to be false
        end
        it 'should not also identify as an archival series' do
          expect(document.is_archival_series?).to be false
        end
      end
    end

    describe "#parent_unittitles" do
      subject { document.parent_unittitles }
      it { is_expected.to eql ["Series I", "Series II"] }
    end

    describe "#unittitle" do
      subject { document.unittitle }
      it { is_expected.to eql "The Unit Title" }
    end

    describe "#library" do
      subject { document.library }
      it { is_expected.to eql "The Fales Library & Special Collections" }
    end

  end

end
