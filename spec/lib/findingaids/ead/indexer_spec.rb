require 'spec_helper'

describe Findingaids::Ead::Indexer do

  let(:indexer) { Findingaids::Ead::Indexer.new }

  describe '.delete_all' do
  end

  describe '#index' do
    subject { indexer.index(file) }
    context 'when file is not passed in' do
      let(:file) { nil }
      it 'should throw an argument error' do
        expect { subject }.to raise_error ArgumentError
      end
    end
    context 'when file is passed in' do
      context 'and file is valid' do
        let(:file) { Rails.root.join('spec','fixtures','fales','bloch.xml').to_s }
        it 'should index file' do
          expect(subject).to be_true
        end
      end
      context 'and file is invalid' do
        let(:file) { Rails.root.join('spec','fixtures','ead','nothing.xml').to_s }
        it 'should not index file' do
          expect(subject).to be_false
        end
      end
    end
    context 'when file is a directory' do
      let(:file) { Rails.root.join('spec','fixtures','tamiment').to_s }
      it 'should index files in directory' do
        expect(subject).to be_true
      end
    end
  end

  describe '#reindex_changed' do
  end

end
