require 'test_helper'

class ApplicationControllerTest < ActionController::TestCase
  
  setup :activate_authlogic

  def setup
   current_user = UserSession.create(users(:global_admin))
  end
  
  test "should test development functions" do
    controller.current_user_dev
    assert assigns(:current_user)
  end
  
  
end