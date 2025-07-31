class MessagesController < ApplicationController
  def create
    @conversation = Current.user.conversations.find(params[:conversation_id])
    @message = @conversation.messages.new(message_params)
    @message.role = :user
    @message.character = @conversation.room.characters.where(members: { playing: true }).first
    @message.status = :completed

    if @message.save
      message = @conversation.messages.new
      CoversationCompletionJob.perform_later(@conversation, @message)
      render turbo_stream: turbo_stream.replace(helpers.dom_id(message, :form), partial: "messages/form", locals: { message: message })
    else
      render turbo_stream: turbo_stream.replace(helpers.dom_id(@message, :form), partial: "messages/form", locals: { message: @message })
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
