class ConversationsController < ApplicationController
  before_action :set_room, only: %i[ index create ]
  before_action :set_conversation, only: %i[ destroy ]

  def index
    @pagy, @conversations = pagy(@room.conversations.order(id: :desc))
    @current_conversation = if params[:current_id]
      @room.conversations.find(params[:current_id])
    end
  end

  def create
    @conversation = @room.conversations.create(user: Current.user)
    redirect_to room_path(@room)
  end

  def destroy
    @conversation.destroy
    render turbo_stream: turbo_stream.remove(@conversation)
  end

  private

  def set_room
    @room = Current.user.rooms.find(params[:room_id])
  end

  def set_conversation
    @conversation = Current.user.conversations.find(params[:id])
  end
end
