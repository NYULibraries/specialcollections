require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  
  setup :activate_authlogic

  def setup
   current_user = UserSession.create(users(:global_admin))
  end

  test "should get index" do
    get :index
    assert_not_nil assigns(:users)
    assert_response :success
    assert_template :index
  end

  test "search returns result" do
    get :index, :search => "admin"
    assert_not_nil assigns(:users)
  end

  test "should show user" do
    get :show, :id => User.find(:first).id
    assert_not_nil assigns(:user)
    assert_response :success
    assert_template :show
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
     delete :destroy, :id => users(:invalid_admin1).id
    end

    assert_redirected_to users_path
  end
   
end