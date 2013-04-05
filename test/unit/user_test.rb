require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  setup :activate_authlogic
  
  test "user search" do
    assert_not_empty User.search("Marcus T")
    assert_not_empty User.search("Admin")
    assert_not_empty User.search("admin")
    assert_empty User.search("noemail@university.edu")
  end
  
end
