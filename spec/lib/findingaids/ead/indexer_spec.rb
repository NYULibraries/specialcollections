require 'spec_helper'

describe Findingaids::Ead::Indexer do

  let(:indexer) { Findingaids::Ead::Indexer.new('./spec/fixtures') }
  let(:message) { "Deleting file tamwag/TAM.075-ead.xml EADID='tam_075', Deleting file tamwag/WAG.221-ead.xml EADID='wag_221'" }

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
      let(:file) { Rails.root.join('spec','fixtures','tamwag').to_s }
      it 'should index files in directory' do
        expect(subject).to be_true
      end
    end
  end

  describe '#update_or_delete' do
    before {
      Findingaids::Ead::Indexer.any_instance.stub(:update).and_return(:true)
      Findingaids::Ead::Indexer.any_instance.stub(:delete).and_return(:true)
    }
    subject { indexer.send(:update_or_delete, status, file, message) }
    context 'when file exists' do
      let(:file) { './spec/fixtures/fales/bytsura.xml' }
      let(:status) { 'M' }
      it { should be_true }
    end
    context 'when file does not exist' do
      let(:file) { './spec/fixtures/nothing_here' }
      context 'and status is Delete' do
        let(:status) { 'D' }
        it { should be_true }
      end
      context 'and status IS NOT Delete' do
        let(:status) { 'M' }
        it { should be_nil }
      end
    end
  end

  describe '#reindex_changed_since_last_commit' do
    before {
      Findingaids::Ead::Indexer.any_instance.stub(:reindex_changed).and_return(:true)
    }
    subject { indexer.send(:reindex_changed_since_last_commit) }
    it { should be_true }
  end

  describe '#reindex_changed_since_yesterday' do
    before {
      Findingaids::Ead::Indexer.any_instance.stub(:reindex_changed).and_return(:true)
    }
    subject { indexer.send(:reindex_changed_since_yesterday) }
    it { should be_true }
  end

  describe '#reindex_changed_since_last_week' do
    before {
      Findingaids::Ead::Indexer.any_instance.stub(:reindex_changed).and_return(:true)
    }
    subject { indexer.send(:reindex_changed_since_last_week) }
    it { should be_true }
  end

  describe '#reindex_changed_since_days_ago' do
    context 'when given a valid number of days' do
      subject { indexer.send(:reindex_changed_since_days_ago, 0) }
      it { should be_true }
    end

    context 'when given an invalid number of days' do
      subject { indexer.send(:reindex_changed_since_days_ago, 'foo') }
      it 'should throw an argument error' do
        expect { subject }.to raise_error ArgumentError
      end
    end
  end

  describe '#reindex_changed' do
    before {
      Findingaids::Ead::Indexer.any_instance.stub(:update_or_delete).and_return(:true)
    }
    subject { indexer.send(:reindex_changed, indexer.send(:commits)) }
    it { should be_true }
  end

  describe '#update' do
    let(:file) { './spec/fixtures/fales/bytsura.xml' }
    subject { indexer.send(:update, file) }
    before { SolrEad::Indexer.any_instance.stub(:update).and_return(:true) }
    context 'when file is not passed in' do
      let(:file) { nil }
      it 'should throw an argument error' do
        expect { subject }.to raise_error ArgumentError
      end
    end
    context 'when file is passed in' do
      it { should be_true }
    end
    context 'when SolrEad::Indexer.update fails' do
      before { SolrEad::Indexer.any_instance.stub(:update).and_raise(:ArgumentError) }
      it { should be_false }
    end
  end

  describe '#delete' do
    let(:file) { './spec/fixtures/fales/bytsura.xml' }
    let(:eadid) { 'bytsura' }
    subject { indexer.send(:delete, file, eadid) }
    context 'when file is not passed in' do
      before { SolrEad::Indexer.any_instance.stub(:delete).and_return(:true) }
      let(:file) { nil }
      it 'should throw an argument error' do
        expect { subject }.to raise_error ArgumentError
      end
    end
    context 'when file is passed in' do
      it { should be_true }
      context 'and eadid is passed in' do
        it { should be_true }
      end
      context 'but eadid is not passed in' do
        let(:eadid) { nil }
        it { should be_true }
      end
    end
    context 'when SolrEad::Indexer.delete fails' do
      before { SolrEad::Indexer.any_instance.stub(:delete).and_raise(:ArgumentError) }
      it { should be_false }
    end
  end

  describe '#commits' do
    subject { indexer.send(:commits) }
    it { should_not be_nil }
    it { should be_a Array }
  end

 describe '#changed_files' do
   subject { indexer.send(:changed_files, indexer.send(:commits)) }
   it { should_not be_nil }
   it { should be_a Array }
 end

 describe '#get_eadid_from_message' do
   let(:filename) { "tamwag/WAG.221-ead.xml" }
   subject { indexer.send(:get_eadid_from_message, filename, message)}
   context 'when commit message contains multiple deletes' do
     it { should eql 'wag_221' }
   end
   context 'when commit message contains multiple updates' do
     let(:message) { "Updating file tamwag/oh_065.xml, Updating file tamwag/tam_085.xml" }
     let(:filename) { "tamwag/oh_065.xml" }
     it { should be_nil }
   end
   context 'when commit message does not contain the filename' do
     let(:filename) { "tamwag/notthere.xml" }
     it { should be_nil }
   end
   context 'when commit message contains a single update' do
     let(:message) { "Updating file tamwag/wag_221.xml" }
     it { should be_nil }
   end
   context 'when commit message contains a single delete' do
     let(:message) { "Deleting file tamwag/WAG.221-ead.xml EADID='wag_221'" }
     it { should eql 'wag_221' }
   end
 end

end
