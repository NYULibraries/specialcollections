require 'spec_helper'

describe Findingaids::Ead::Behaviors::Dates do

  include Findingaids::Ead::Behaviors::Dates

  describe "DATE_RANGES" do
    Findingaids::Ead::Behaviors::Dates::DATE_RANGES.each do |date_range|
      subject { date_range }
      it { should be_instance_of Hash }
    end
  end

  describe "UNDATED" do
    subject { Findingaids::Ead::Behaviors::Dates::UNDATED }
    it { should eql "undated & other" }
  end

end
