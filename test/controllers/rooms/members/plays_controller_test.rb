require "test_helper"

class Rooms::Members::PlaysControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    @room = create(:room, user: @user)
    @character = create(:character, user: @user)
    @member = create(:member, room: @room, character: @character)
  end

  test "should play character" do
    sign_in_as @user

    post room_member_play_url(@room, @member)
    assert_redirected_to room_members_url(@room)
    assert @member.reload.playing?
  end

  test "should stop playing character" do
    @member.update(playing: true)
    sign_in_as @user

    delete room_member_play_url(@room, @member)
    assert_redirected_to room_members_url(@room)
    assert_not @member.reload.playing?
  end
end
