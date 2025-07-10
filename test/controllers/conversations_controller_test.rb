require "test_helper"

class ConversationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    @room = create(:room, user: @user)
    @conversation = create(:conversation, room: @room, user: @user)
  end

  test "should get index" do
    sign_in_as @user
    get room_conversations_url(@room)
    assert_response :success
  end

  test "should create conversation" do
    sign_in_as @user
    assert_difference("Conversation.count", 1) do
      post room_conversations_url(@room)
    end
    assert_redirected_to room_url(@room)
  end

  test "should destroy conversation" do
    sign_in_as @user

    assert_difference("Conversation.count", -1) do
      delete conversation_url(@conversation)
    end
    assert_response :success
  end
end
