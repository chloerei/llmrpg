require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_registration_path
    assert_response :success
  end

  test "should create user and start session" do
    assert_difference "User.count", 1 do
      post registration_path, params: {
        user: {
          email: "user@example.com",
          password: "password",
          password_confirmation: "password"
        }
      }
    end
    assert_redirected_to rooms_url
  end

  test "should not create user with dup email" do
    create(:user, email: "user@example.com")
    assert_no_difference "User.count" do
      post registration_path, params: {
        user: {
          email: "user@example.com",
          password: "password",
          password_confirmation: "password"
        }
      }
    end
    assert_response :unprocessable_entity
  end
end
