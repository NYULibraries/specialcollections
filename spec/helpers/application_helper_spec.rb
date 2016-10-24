require "spec_helper"

describe ApplicationHelper do

  let(:repository) {"The Fales Library & Special Collections"}
  let(:params) {{:repository => repository}}
  let(:repositories) { Findingaids::Repositories.repositories }

  before do
    allow(helper).to receive(:repositories).and_return repositories
    allow(helper).to receive(:params).and_return params
  end

  describe "#current_repository" do
    subject { helper.current_repository.first }
    it { should eql "fales" }
  end

  describe "#searching?" do
    subject { helper.searching? }
    context "when we ARE NOT actively searching the index" do
      it { should be_false }
    end
    context "when we ARE actively searching the index" do
      let(:params) {{:q => "query"}}
      it { should be_true }
    end
  end

  describe "#current_repository_url" do
    subject { helper.current_repository_url }
    context "when the repository is The Fales Library & Special Collections" do
      it { should eql "fales" }
    end
    context "when the repository is Tamiment Library & Wagner Labor Archives" do
      let(:repository) { "Tamiment Library & Wagner Labor Archives" }
      it { should eql "tamiment" }
    end
  end

  describe "#current_repository_home_text?" do
    subject { helper.current_repository_home_text? }
    context "when current repository has home text" do
      it { should_not be_empty }
    end
    context "when current repository doesn't exist" do
      let(:repository) { "The Nothing Library" }
      it { should be_false }
    end
  end

  describe "#maintenance_mode?" do
    subject { helper.maintenance_mode? }
    it { should_not be_nil }
  end

end
