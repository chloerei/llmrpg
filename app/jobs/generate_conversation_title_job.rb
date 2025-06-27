class GenerateConversationTitleJob < ApplicationJob
  queue_as :default

  def perform(conversation)
    messages = conversation.messages.map(&:to_openai_message)

    messages << {
      role: "user",
      content: "Generate a concise title for this conversation based on the messages above, only ouput title content without quote."
    }

    openai = OpenAI::Client.new
    completion = openai.chat.completions.create(
      model: "deepseek-chat",
      messages: messages
    )

    conversation.title = completion[:choices][0][:message][:content]
    conversation.save
  end
end
