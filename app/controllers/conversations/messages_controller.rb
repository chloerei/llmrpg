class Conversations::MessagesController < ApplicationController
  before_action :set_conversation

  def create
    @message = @conversation.messages.new(message_params)
    @message.creator = @conversation.persona
    @message.status = :completed

    if @message.save
      # TODO: multiple characters, who to response?
      @conversation.messages.create(creator: @conversation.character)
      render turbo_stream: turbo_stream.replace("new-message-form", partial: "conversations/messages/form", locals: { message: @conversation.messages.new })
    else
      render turbo_stream: turbo_stream.replace("new-message-form", partial: "conversations/messages/form", locals: { message: @message })
    end
  end

  def completion
    @message = @conversation.messages.find(params[:id])

    response.headers["Content-Type"] = "text/event-stream"

    response.headers["rack.hijack"] = proc do |stream|
      Thread.new do
        perform_completion(@message, stream)
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

  def perform_completion(message, stream)
    sse = ActionController::Live::SSE.new(stream, retry: 300)
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

    conversation.messages.where("id < ?", @message.id).order(id: :asc).each do |message|
      messages << {
        role: message.creator == conversation.persona ? "user" : "assistant",
        content: message.content
      }
    end

    logger.info "Messages: #{messages.inspect}"

    openai = OpenAI::Client.new

    openai_stream = openai.chat.completions.stream_raw(
      messages: messages,
      model: "deepseek-chat",
    )

    content = ""
    openai_stream.each do |chunk|
      puts chunk
      data = {
        content: chunk[:choices][0][:delta][:content],
        done: chunk[:choices][0][:finish_reason].present?
      }
      content += data[:content]
      sse.write(data, event: "message")
    end

    logger.info content
    @message.content = content
    @message.status = :completed
    @message.save!
  ensure
    sse.close
  end
end
