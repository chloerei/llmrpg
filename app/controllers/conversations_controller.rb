class ConversationsController < ApplicationController
  before_action :set_conversation, only: %i[ destroy ]

  def create
    @room = Current.user.rooms.find(params[:room_id])
    @conversation = @room.conversations.create(user: Current.user)
    redirect_to room_path(@room)
  end

  def destroy
    @conversation.destroy!

    redirect_to room_path(@conversation.room), status: :see_other, notice: "Conversation was successfully destroyed."
  end

  private

  def set_conversation
    @conversation = Current.user.conversations.find(params[:id])
  end
end
