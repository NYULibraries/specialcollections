require 'spec_helper'
require 'git'

describe Findingaids::Ead::Indexer do

  let(:indexer) { Findingaids::Ead::Indexer.new }
  let(:file) { Rails.root.join('spec','fixtures','examples','ead_sample.xml') }

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
        it 'should index file' do
          expect(subject).to be_true
        end
      end
      context 'and file is invalid' do
        let(:file) { Rails.root.join('spec','fixtures','ead','nothing.xml') }
        it 'should not index file' do
          expect(subject).to be_false
        end
      end
    end
    context 'when file is a directory' do
      let(:file) { Rails.root.join('spec','fixtures','tamwag') }
      it 'should index files in directory' do
        expect(subject).to be_true
      end
    end
  end

  describe '#reindex_changed' do
    subject { indexer.reindex_changed }
    context 'when there are no changes' do
      it 'should do nothing' do
        expect(subject).to be_true
      end
    end
    context 'when there are changes' do
      before do
        open(Rails.root.join('spec','fixtures','examples','test-01.xml'), 'w') do |f|
          f.write open(Rails.root.join('spec','fixtures','examples','test-template.xml')).read
        end
      end
      it 'should reindex the changed files' do
      end
    end
  end

end
