require 'rails_helper'

describe ApplicationController do

  describe "#current_user_dev" do
    subject { controller.current_user_dev }
    it { should be_instance_of(User) }
    its(:username) { should be == "Methuselah969" }
  end

end
