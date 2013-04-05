require 'test_helper'

class UserSessionTest < ActiveSupport::TestCase

  setup :activate_authlogic

  test "get additional attributes admin" do
    # Use a real user from PDS to verify address
    user_session = UserSession.create(users(:real_user))
    set_dummy_pds_user(user_session)
    user_attributes = user_session.additional_attributes
    # Make sure all parts of address are set correctly
    assert_not_nil(user_attributes[:findingaids_admin])
    assert(user_attributes[:findingaids_admin])
  end

end