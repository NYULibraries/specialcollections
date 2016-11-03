require 'rails_helper'

describe CatalogController do

  let(:search_field) { "all_fields" }
  let(:q) { "" }
  let(:rows) { "20" }

  before(:all) do
    Findingaids::Ead::Indexer.delete_all
    indexer = Findingaids::Ead::Indexer.new
    indexer.index(Rails.root.join('spec','fixtures','fales','bloch.xml').to_s)
    indexer.index(Rails.root.join('spec','fixtures','fales','EAD_example_weights.xml').to_s)
    indexer.index(Rails.root.join('spec','fixtures','fales','EAD_example_weights_collection.xml').to_s)
  end

  describe "GET /catalog" do
    before { get :index, q: q, search_field: search_field, rows: rows }
    subject { assigns(:document_list) }

    context 'when searching for a known indexed collection by keyword' do
      let(:q) { "bloch" }
      its(:count) { is_expected.to be 1 }
    end

    context 'when searching for a keyword found in many different levels of a document' do
      let(:q) { "solr" } # A bit confusingly "solr" is used as a keyword in the test EAD loaded above, EAD_example_weights.xml

      # See #qf_fields in Findingaids::Solr::CatalogHelpers for solr weighting

      its(:count) { is_expected.to be 11 }
      it { expect(subject[0].id).to eql "weight" }
      it { expect(subject[1].id).to eql "weightref11" }
      it { expect(subject[2].id).to eql "weightref12" }
      it { expect(subject[3].id).to eql "weightref35" }
      it { expect(subject[4].id).to eql "weightref37" }
      it { expect(subject[5].id).to eql "weightref36" }
      it { expect(subject[6].id).to eql "weightref41" }
      it { expect(subject[7].id).to eql "weightref42" }
      it { expect(subject[8].id).to eql "weightref38" }
      it { expect(subject[9].id).to eql "weightref39" }
      it { expect(subject[10].id).to eql "weightref43" }
    end

    context 'when searching for a specific author' do
      let(:q) { "Kate Pechekhonova Accuracy" }
      it 'should boost results with that author in the <author> field' do
        expect(subject.first.id).to eql "weightcollection"
      end
    end

    context 'when searching for a keyword in the abstract field' do
      let(:q) { "Simplicity" }
      it 'should boost results with that keyword in the <abstract> field' do
        expect(subject.first.id).to eql "weightcollection"
      end
    end

    context 'when searching for a keyword in the acqinfo field' do
      let(:q) { "Transparency" }
      it 'should boost results with that keyword in the <acqinfo> field' do
        expect(subject.first.id).to eql "weightcollection"
      end
    end
  end

end
