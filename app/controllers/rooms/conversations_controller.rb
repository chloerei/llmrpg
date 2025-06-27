class Rooms::ConversationsController < Rooms::BaseController
  before_action :set_conversation, only: %i[ show edit update destroy ]

  def show
  end

  def edit
  end

  def create
    @conversation = @room.conversations.new
    @conversation.user = Current.user

    if @conversation.save!
      redirect_to room_conversation_url(@room, @conversation), notice: "Conversation was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @conversation.update(conversation_params)
      redirect_to room_conversation_url(@room, @conversation), notice: "Conversation was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @conversation.destroy!

    redirect_to room_path(@room), status: :see_other, notice: "Conversation was successfully destroyed."
  end

  private

  def set_conversation
    @conversation = @room.conversations.find(params.expect(:id))
  end

  def conversation_params
    params.expect(conversation: [ :title ])
  end
end
