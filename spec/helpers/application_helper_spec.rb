require 'rails_helper'

describe ApplicationHelper do

  let(:repository) {"The Fales Library & Special Collections"}
  let(:params) {{:repository => repository}}
  let!(:repositories) { Findingaids::Repositories.repositories }

  before do
    allow(helper).to receive(:repositories).and_return repositories
    allow(helper).to receive(:params).and_return params
  end

  describe "#current_repository" do
    subject { helper.current_repository.first }
    it { is_expected.to eql "fales" }
  end

  describe "#searching?" do
    subject { helper.searching? }
    context "when we ARE NOT actively searching the index" do
      it { is_expected.to be false }
    end
    context "when we ARE actively searching the index" do
      let(:params) {{:q => "query"}}
      it { is_expected.to be true }
    end
  end

  describe "#current_repository_url" do
    subject { helper.current_repository_url }
    context "when the repository is The Fales Library & Special Collections" do
      it { is_expected.to eql "fales" }
    end
    context "when the repository is Tamiment Library & Wagner Labor Archives" do
      let(:repository) { "Tamiment Library & Wagner Labor Archives" }
      it { is_expected.to eql "tamiment" }
    end
  end

  describe "#current_repository_home_text?" do
    subject { helper.current_repository_home_text? }
    context "when current repository has home text" do
      it { is_expected.to_not be_empty }
    end
    context "when current repository doesn't exist" do
      let(:repository) { "The Nothing Library" }
      it { is_expected.to be false }
    end
  end

  describe "#maintenance_mode?" do
    subject { helper.maintenance_mode? }
    it { is_expected.to_not be_nil }
  end

  describe "#repositories" do
    subject(:repositories) { helper.repositories }

    context "when repository is Fales" do
      subject(:repository) { repositories['fales'] }
      it { expect(repository['display']).to eql("The Fales Library & Special Collections") }
      it { expect(repository['url']).to eql("fales") }
      it { expect(repository['admin_code']).to eql("fales") }
    end

    context "when repository is Tamiment " do
      subject(:repository) { repositories['tamiment'] }
      it { expect(repository['display']).to eql("Tamiment Library & Wagner Labor Archives") }
      it { expect(repository['url']).to eql("tamiment") }
      it { expect(repository['admin_code']).to eql("tamwag") }
    end

    context "when repository is NYU Archives " do
      subject(:repository) { repositories['universityarchives'] }
      it { expect(repository['display']).to eql("New York University Archives") }
      it { expect(repository['url']).to eql("universityarchives") }
      it { expect(repository['admin_code']).to eql("archives") }
    end

    context "when repository is NYHS" do
      subject(:repository) { repositories['nyhistory'] }
      it { expect(repository['display']).to eql("New-York Historical Society") }
      it { expect(repository['url']).to eql("nyhistory") }
      it { expect(repository['admin_code']).to eql("nyhs") }
    end

    context "when repository is BHS" do
      subject(:repository) { repositories['brooklynhistory'] }
      it { expect(repository['display']).to eql("Center for Brooklyn History") }
      it { expect(repository['url']).to eql("brooklynhistory") }
      it { expect(repository['admin_code']).to eql("bhs") }
    end

    context "when repository is Poly Archives" do
      subject(:repository) { repositories['poly'] }
      it { expect(repository['display']).to eql("Poly Archives") }
      it { expect(repository['url']).to eql("poly") }
      it { expect(repository['admin_code']).to eql("poly") }
    end

    context "when repository is RISM" do
      subject(:repository) { repositories['rism'] }
      it { expect(repository['display']).to eql("Research Institute for the Study of Man") }
      it { expect(repository['url']).to eql("rism") }
      it { expect(repository['admin_code']).to eql("rism") }
    end

    context "when repository is Akkasah" do
      subject(:repository) { repositories['akkasah'] }
      it { expect(repository['display']).to eql("Akkasah Center for Photography at NYU Abu Dhabi") }
      it { expect(repository['url']).to eql("akkasah") }
      it { expect(repository['admin_code']).to eql("akkasah") }
    end

  end

end
