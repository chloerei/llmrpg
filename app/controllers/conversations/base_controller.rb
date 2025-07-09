class Conversations::BaseController < ApplicationController
  before_action :set_conversation

  private

  def set_conversation
    @conversation = Current.user.conversations.find(params[:conversation_id])
  end
end
