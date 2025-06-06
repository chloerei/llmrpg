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
      role: "user",
      content: <<~EOF
        ## My settings

        ### Name

        #{@conversation.persona.name}

        ### Description

        #{@conversation.persona.description}

        ## Your settings

        ### Name

        #{@conversation.character.name}

        ### Description

        #{@conversation.character.description}
      EOF
    }

    message = @conversation.messages.new(message_params)
    message.creator = @conversation.persona
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
      content: message.content
    }

    response_message = @conversation.messages.create(
      creator: @conversation.character,
      content: "",
    )

    sse.write({
      action: "create",
      message: {
        id: response_message.id,
        html: render_to_string(partial: "messages/message", locals: { message: response_message })
      }
    })

    openai = OpenAI::Client.new
    openai_stream = openai.chat.completions.stream_raw(
      messages: messages,
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

    sse.write({
      action: "update",
      message: {
        id: response_message.id,
        html: render_to_string(partial: "messages/message", locals: { message: response_message })
      }
    })
  ensure
    sse.close
  end
end
