module ConversationScoped
  extend ActiveSupport::Concern

  included do
    before_action :set_conversation
  end

  private

  def set_conversation
    @conversation = @room.conversations.find(params[:conversation_id])
  end
end
