require "test_helper"

class GenerateUserSeedDataJobTest < ActiveJob::TestCase
  test "should generate seed data for user" do
    user = create(:user)

    GenerateUserSeedDataJob.perform_now(user)

    assert_equal 1, user.characters.count
    assert_equal 1, user.rooms.count
    assert_equal 1, user.rooms.first.members.count
    assert_equal 1, user.rooms.first.conversations.count
    assert_equal 1, user.rooms.first.conversations.first.messages.count
  end
end
