require "test_helper"

class Settings::Account::EmailsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user, email: "user@example.com", password: "password")
  end

  test "should get show" do
    sign_in_as @user
    get settings_account_email_path
    assert_response :success
  end

  test "should update email with valid password" do
    sign_in_as @user
    patch settings_account_email_path, params: { user: { email: "change@example.com", password_challenge: "password" } }
    assert_redirected_to settings_account_email_path
    assert_equal "change@example.com", @user.reload.email
  end

  test "should not update email with invalid password" do
    sign_in_as @user
    patch settings_account_email_path, params: { user: { email: "change@example.com", password_challenge: "wrongpassword" } }
    assert_response :unprocessable_entity
    assert_equal "user@example.com", @user.reload.email
  end
end
