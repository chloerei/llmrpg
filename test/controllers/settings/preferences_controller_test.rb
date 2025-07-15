require "test_helper"

class Settings::PreferencesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user, locale: "en")
  end

  test "should get show" do
    sign_in_as @user
    get settings_preference_path
    assert_response :success
  end

  test "should update preferences" do
    sign_in_as @user
    patch settings_preference_path, params: { user: { locale: "zh-CN" } }
    assert_redirected_to settings_preference_path
    assert_equal "zh-CN", @user.reload.locale
  end
end
