require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user       = users(:mr_example)
    @other_user = users(:archer)
  end

  test "should get new" do
    get signup_url
    assert_response :success
  end

  test "should redirect edit when not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get edit_user_path(@user)

    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)

    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }

    assert flash.empty?
    assert_redirected_to root_url
  end

  test "friendly forwarding should not persist" do
    get edit_user_path(@user)
    log_in_as(@user)

    assert_redirected_to edit_user_url(@user)
    follow_redirect!
    assert_template 'users/edit'

    log_out_user

    assert_redirected_to root_url
    follow_redirect!
    get login_path
    log_in_as(@user)
    assert_redirected_to user_path(@user)
  end

  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end

  test "should not be able to assign admin right at signup" do
    get signup_path
    post signup_path, params: { user: { name:  "Example User",
                                        email: "user@example.com",
                                        password:              "password",
                                        password_confirmation: "password",
                                        admin: true } }

    follow_redirect!

    assert is_logged_in?
    assert_not is_admin?
  end

  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@other_user)
    assert_not @other_user.admin?

    patch user_path(@other_user), params: {
                                    user: { password:              "password",
                                            password_confirmation: "password",
                                            admin: true } }

    assert_not @other_user.reload.admin?
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end
end
