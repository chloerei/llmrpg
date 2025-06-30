require "test_helper"

class Settings::Account::PasswordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user, password: "password")
  end

  test "should get show" do
    sign_in_as @user
    get settings_account_password_path
    assert_response :success
  end

  test "should update password with valid current password" do
    sign_in_as @user
    patch settings_account_password_path, params: { user: { password: "newpassword", password_confirmation: "newpassword", password_challenge: "password" } }
    assert_redirected_to settings_account_password_path
    assert @user.reload.authenticate("newpassword")
  end

  test "should not update password with invalid current password" do
    sign_in_as @user
    patch settings_account_password_path, params: { user: { password: "newpassword", password_confirmation: "newpassword", password_challenge: "wrongpassword" } }
    assert_response :unprocessable_entity
    assert_not @user.reload.authenticate("newpassword")
  end
end
