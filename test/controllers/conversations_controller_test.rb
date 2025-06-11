require "test_helper"

class ConversationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    @persona = create(:persona, user: @user)
    @room = create(:room, user: @user, persona: @persona)
    @conversation = create(:conversation, room: @room, user: @user)
    sign_in_as @user
  end

  test "should create conversation" do
    assert_difference("Conversation.count") do
      post room_conversations_url(@room)
    end

    assert_redirected_to room_conversation_url(@room, Conversation.last)
  end

  test "should get edit" do
    get edit_room_conversation_url(@room, @conversation)
    assert_response :success
  end

  test "should update conversation" do
    patch room_conversation_url(@room, @conversation), params: { conversation: { title: "changed" } }
    assert_redirected_to room_conversation_url(@room, @conversation)
  end

  test "should destroy conversation" do
    assert_difference("Conversation.count", -1) do
      delete room_conversation_url(@room, @conversation)
    end

    assert_redirected_to room_conversations_url(@room)
  end
end
