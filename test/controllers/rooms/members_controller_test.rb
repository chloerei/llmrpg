require "test_helper"

class Rooms::MembersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    @room = create(:room, user: @user)
  end

  test "should get index" do
    sign_in_as @user
    get room_members_path(@room)
    assert_response :success
  end

  test "should get new" do
    sign_in_as @user
    get new_room_member_path(@room)
    assert_response :success
  end

  test "should create member" do
    sign_in_as @user
    character = create(:character, user: @user)
    assert_difference("@room.members.count", 1) do
      post room_members_path(@room), params: { character_ids: [ character.id ] }
    end
    assert_redirected_to room_members_path(@room)
  end
end
