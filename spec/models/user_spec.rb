require 'rails_helper'

describe User do
  subject { User.new }
  it "should be an instance of User" do
    expect(subject).to be_a User
  end
end