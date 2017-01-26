require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get root_url
    assert_response :success
    assert_select "title", "Micropost App"
  end

  test "should get help" do
    get help_url
    assert_response :success
    assert_select "title", "Help | Micropost App"
  end

  test "should get about" do
    get about_url
    assert_response :success
    assert_select "title", "About | Micropost App"
  end

  test "should get contact" do
    get contact_url
    assert_response :success
    assert_select "title", "Contact | Micropost App"
  end

end
