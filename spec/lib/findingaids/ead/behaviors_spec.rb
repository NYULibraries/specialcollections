require 'rails_helper'

describe Findingaids::Ead::Behaviors do

  include Findingaids::Ead::Behaviors

  describe "#repository_display" do

    subject { repository_display }

    context "when EAD variable is a folder" do
      before { stub_const('ENV', {'EAD' => 'spec/fixtures/examples'}) }

      it { should eql("examples") }
    end

    context "when EAD variable is a file" do
      before { stub_const('ENV', {'EAD' => 'spec/fixtures/examples/bytsura.xml'}) }

      it { should eql("examples")}
    end

    context "when there is no EAD variable" do
      before { stub_const('ENV', {'EAD' => nil}) }
      it { should be_nil }
    end

  end

  describe "#get_language_from_code" do

    let(:language_code) { "eng" }

    subject { get_language_from_code(language_code) }

    context "when language code is eng" do
      it { should eql("English") }
    end

    context "when language code is ger" do
      let(:language_code) { "ger" }
      it { should eql("German") }
    end

  end

  describe "#fix_subfield_demarcators" do
    let(:subfield) { "Long Island (N.Y.) |x History |y 17th century" }

    subject { fix_subfield_demarcators(subfield) }

    context "when subfield is Long Island (N.Y.) |x History |y 17th century" do
      it { should eql("Long Island (N.Y.) -- History -- 17th century")}
    end

    context "when subfield is Chemistry |w History |y 19th century" do
      let(:subfield) { "Chemistry |w History |y 19th century" }
      it { should eql("Chemistry -- History -- 19th century")}
    end
  end


end
