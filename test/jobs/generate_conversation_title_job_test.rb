require "test_helper"

class GenerateConversationTitleJobTest < ActiveJob::TestCase
  test "should generate titel" do
    conversation = create(:conversation)

    stub_request(:post, "https://openai.local/api/chat/completions").
      to_return(
        headers: { "Content-Type" => "application/json" },
        body: {
          choices: [
            {
              message: {
                content: "generated title"
              }
            }
          ]
        }.to_json
      )

    GenerateConversationTitleJob.perform_now(conversation)
    assert_equal "generated title", conversation.title
  end
end
