class Conversations::CompletionsController < ApplicationController
  before_action :set_conversation

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

  def set_conversation
    @conversation = Current.user.conversations.find(params[:conversation_id])
  end

  def message_params
    params.require(:message).permit(:content)
  end

  def perform_completion(stream)
    sse = ActionController::Live::SSE.new(stream, retry: 300, event: "message")

    messages = []

    messages << {
      role: "system",
      content: <<~EOF
        You are a role playing assistant in a chat room. You will reply to the user as a character based on the settings provided.
      EOF
    }

    character_settings = @conversation.room.characters.map do |character|
      <<~EOF
        name: #{character.name}

        description: #{character.description}
      EOF
    end.join("\n\n")

    messages << {
      role: "user",
      content: <<~EOF
        ## User settings

        name: #{@conversation.room.persona.name}

        description: #{@conversation.room.persona.description}

        ## Characters settings

        #{character_settings}
      EOF
    }

    @conversation.messages.each do |message|
      messages << {
        role: message.creator_type == "Character" ? "assistant" : "user",
        content: "#{message.creator.name}: #{message.content}"
      }
    end

    message = @conversation.messages.new(message_params)
    message.creator = @conversation.room.persona
    message.status = :completed
    message.save

    sse.write({
      action: "create",
      message: {
        id: message.id,
        html: render_to_string(partial: "messages/message", locals: { message: message })
      }
    })

    messages << {
      role: "user",
      content: "#{message.creator.name}: #{message.content}"
    }

    openai = OpenAI::Client.new

    @conversation.room.characters.each do |character|
      response_message = @conversation.messages.create(
        creator: character,
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
        messages: messages + [{
          role: "user",
          content: "Continue conversation as #{character.name}, without character name prefix."
        }],
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

      messages << {
        role: "assistant",
        content: "#{character.name}: #{response_message.content}"
      }

      sse.write({
        action: "update",
        message: {
          id: response_message.id,
          html: render_to_string(partial: "messages/message", locals: { message: response_message })
        }
      })
    end
  ensure
    sse.close
  end
end
