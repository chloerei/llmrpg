class Rooms::Conversations::BaseController < Rooms::BaseController
  before_action :set_conversation

  private

  def set_conversation
    @conversation = @room.conversations.find(params[:conversation_id])
  end
end
