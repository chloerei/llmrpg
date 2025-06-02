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

  private

  def set_conversation
    @conversation = Current.user.conversations.find(params[:conversation_id])
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
