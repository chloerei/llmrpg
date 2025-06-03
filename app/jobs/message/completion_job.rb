class Message::CompletionJob < ApplicationJob
  queue_as :default

  def perform(message)
    conversation = message.conversation

    messages = []

    messages << {
      role: "user",
      content: <<~EOF
        ## My settings

        ### Name

        #{conversation.persona.name}

        ### Description

        #{conversation.persona.description}

        ## Your settings

        ### Name

        #{conversation.character.name}

        ### Description

        #{conversation.character.description}
      EOF
    }

    conversation.messages.where("id < ?", message.id).order(id: :asc).each do |message|
      messages << {
        role: message.creator == conversation.persona ? "user" : "assistant",
        content: message.content
      }
    end

    openai = OpenAI::Client.new

    stream = openai.chat.completions.stream_raw(
      messages: messages,
      model: "deepseek-chat",
    )

    message.content = ""
    stream.each do |chunk|
      message.content += chunk[:choices][0][:delta][:content]
      message.save
    end

    message.status = :completed
    message.save
  end
end
