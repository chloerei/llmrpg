class Conversations::CompletionsController < Conversations::BaseController
  def create
    response.headers["Content-Type"] = "text/event-stream"

    response.headers["rack.hijack"] = proc do |stream|
      Thread.new do
        perform_completion(stream)
      end
    end

    head :ok
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end

  def perform_completion(stream)
    sse = ActionController::Live::SSE.new(stream, retry: 300, event: "message")

    messages = []

    character_description = @conversation.room.characters.map do |character|
      <<~EOF
        name: #{character.name}

        description: #{character.description}
      EOF
    end.join("\n\n")

    messages << {
      role: "user",
      content: <<~EOF
        You are a role playing assistant in a chat room.

        Use Markdown format.

        ## Room description

        #{@conversation.room.description}

        ## Conversation description

        #{@conversation.description}

        ## Characters description

        #{character_description}
      EOF
    }

    @conversation.messages.each do |message|
      messages << message.to_openai_message
    end

    message = @conversation.messages.new(message_params)
    message.role = :user
    message.character = @conversation.room.characters.where(members: { playing: true }).first
    message.status = :completed
    message.save

    sse.write({
      action: "create",
      message: {
        id: message.id,
        html: render_to_string(partial: "messages/message", locals: { message: message })
      }
    })

    messages << message.to_openai_message

    openai = OpenAI::Client.new

    @conversation.room.characters.where(members: { playing: false }).each do |character|
      response_message = @conversation.messages.create(
        character: character,
        role: :assistant,
        content: "",
      )

      sse.write({
        action: "create",
        message: {
          id: response_message.id,
          html: render_to_string(partial: "messages/message", locals: { message: response_message })
        }
      })

      logger.info messages.inspect

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
          response_message.content += content_chunk
          sse.write({
            action: "append",
            message: {
              id: response_message.id,
              content: content_chunk
            }
          })
        end
      end

      response_message.status = :completed
      response_message.save

      messages << response_message.to_openai_message

      sse.write({
        action: "update",
        message: {
          id: response_message.id,
          html: render_to_string(partial: "messages/message", locals: { message: response_message })
        }
      })
    end

    if @conversation.title.blank?
      GenerateConversationTitleJob.perform_later(@conversation)
    end
  ensure
    sse.close
  end
end
