require "test_helper"

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Example User", profile: "https://libecity.com/user_profile/test", 
                     password: "111111", password_confirmation: "111111")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "     "
    assert_not @user.valid?
  end

  test "profile should be present" do
    @user.profile = "    "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "profile validation should accept valid urls" do
    valid_urls = %w[https://libecity.com/user_profile/test]
    valid_urls.each do |valid_url|
      @user.profile = valid_url
      assert @user.valid?, "#{valid_url.inspect} は有効なURLでなければならない"
    end
  end

  test "profile validation should reject invalid urls" do
    invalid_urls = %w[libecity.com/user_profile/]
    invalid_urls.each do |invalid_url|
      @user.profile = invalid_url
      assert_not @user.valid?, "#{invalid_url.inspect} は無効なURLでなければならない"
    end
  end

  test "profile url should be unique" do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end

  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
end
