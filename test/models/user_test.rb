require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Example User", email: "user@example.com")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "     "

    assert_not @user.valid?
    assert @user.errors.details[:name].length == 1 &&
           @user.errors.details[:name][0][:error] == :blank
  end

  test "name should not be too short" do
    @user.name = "Q"

    assert_not @user.valid?
    assert @user.errors.details[:name].length == 1 &&
           @user.errors.details[:name][0][:error] == :too_short
  end

  test "name should not be too long" do
    @user.name = "Q" * 51
    assert_not @user.valid?
    assert @user.errors.details[:name].length == 1 &&
           @user.errors.details[:name][0][:error] == :too_long
  end

  test "name should not contain whitespace" do
    invalid_names = ["foo\tbar", "\ronald", "An\na"]

    invalid_names.each do |name|
      @user.name = name

      assert_not @user.valid?, "#{name.inspect} should not be valid"
      assert @user.errors.details[:name].length == 1 &&
             @user.errors.details[:name][0][:error] == :invalid
    end
  end

  test "email should be present" do
    @user.email = nil

    assert_not @user.valid?
    assert @user.errors.details[:email].any? { |e| e[:error] == :blank }
  end

  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save

    assert_not duplicate_user.valid?
  end

  test "email should not be too long" do
    @user.email = "#{"a"*240}@somedomain.com"

    assert_not @user.valid?
    assert @user.errors.details[:email].length == 1 &&
           @user.errors.details[:email][0][:error] == :too_long
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]

    valid_addresses.each do |address|
      @user.email = address
      assert @user.valid?, "#{address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid address" do
    invalid_addresses = %w[foo@bar ^0!@=-m.com user@example,com user_at_foo.org
                           user.name@example. foo@bar_baz.com foo@bar+baz.com foo@bar..com]

    invalid_addresses.each do |address|
      @user.email = address
      assert_not @user.valid?, "#{address.inspect} should not be valid"

      assert @user.errors.details[:email].length == 1 &&
             @user.errors.details[:email][0][:error] == :invalid
    end
  end

  test "email should be saved to database in lowercase" do
    test_email  = "HelLo@eMail.COM"
    @user.email = test_email
    @user.save
    @user.reload

    assert_equal @user.email, test_email.downcase
  end
end
