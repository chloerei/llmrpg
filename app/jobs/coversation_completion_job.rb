class CoversationCompletionJob < ApplicationJob
  queue_as :default

  def perform(conversation, message)
    # destroy newer messages if any
    conversation.messages.where("id > ?", message.id).destroy_all

    # context prompts
    messages = []

    character_prompts = conversation.room.characters.map do |character|
      <<~EOF
        ### #{character.name}

        #{character.prompt}
      EOF
    end.join("\n\n")

    messages << {
      role: "user",
      content: <<~EOF
        You are a role-playing assistant in a chat room.

        Use Markdown.

        ## Room

        #{conversation.room.prompt}

        ## Characters

        #{character_prompts}
      EOF
    }

    conversation.messages.each do |message|
      messages << message.to_openai_message
    end

    openai = OpenAI::Client.new

    conversation.room.characters.where(members: { playing: false }).each do |character|
      character_message = conversation.messages.create(
        character: character,
        role: :assistant,
        content: "",
      )

      openai_stream = openai.chat.completions.stream_raw(
        messages: messages + [ {
          role: "user",
          content: "Continue conversation as #{character.name}, without character name prefix."
        } ],
        model: "deepseek-chat",
      )

      openai_stream.each do |chunk|
        content_chunk = chunk[:choices][0][:delta][:content]
        if content_chunk
          character_message.content += content_chunk

          Turbo::StreamsChannel.broadcast_stream_to(
            conversation,
            content: <<~HTML
              <turbo-stream action="message_chunk" target="message_#{character_message.id}">
                <template>#{content_chunk}</template>
              </turbo-stream>
            HTML
          )
        end
      end

      character_message.status = :completed
      character_message.save
    end

    if @conversation.title.blank?
      GenerateConversationTitleJob.perform_later(@conversation)
    end
  end
end
