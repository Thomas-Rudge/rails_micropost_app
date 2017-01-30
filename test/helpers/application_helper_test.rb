require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "full title helper" do
    assert_equal full_title,         "Micropost App"
    assert_equal full_title("Help"), "Help | Micropost App"
  end
end
