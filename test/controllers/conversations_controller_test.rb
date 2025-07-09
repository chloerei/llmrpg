require "test_helper"

class ConversationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    @room = create(:room, user: @user)
    @conversation = create(:conversation, room: @room, user: @user)
  end

  test "should destroy conversation" do
    sign_in_as @user

    assert_difference("Conversation.count", -1) do
      delete conversation_url(@conversation)
    end

    assert_redirected_to room_url(@room)
  end
end
