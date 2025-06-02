class Conversations::MessagesController < ApplicationController
  include ActionController::Live

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

    @conversation.messages.where("id < ?", @message.id).order(id: :asc).each do |message|
      messages << {
        role: message.creator == @conversation.persona ? "user" : "assistant",
        content: message.content
      }
    end

    logger.info "Messages: #{messages.inspect}"

    @openai = OpenAI::Client.new

    stream = @openai.chat.completions.stream_raw(
      messages: messages,
      model: "deepseek-chat",
    )

    response.header["Content-Type"] = "text/event-stream"
    sse = SSE.new(response.stream, retry: 300)

    content = ""
    stream.each do |chunk|
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

  private

  def set_conversation
    @conversation = Current.user.conversations.find(params[:conversation_id])
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
