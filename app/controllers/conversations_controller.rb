class ConversationsController < ApplicationController
  before_action :set_conversation, only: %i[ show edit update destroy ]

  # GET /conversations or /conversations.json
  def index
    @conversations = Conversation.all
  end

  def show
  end

  def new
    @conversation = Conversation.new
  end

  def edit
  end

  def create
    @conversation = Conversation.new(conversation_params)

    if @conversation.save
      redirect_to @conversation, notice: "Conversation was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @conversation.update(conversation_params)
      redirect_to @conversation, notice: "Conversation was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @conversation.destroy!

    redirect_to conversations_path, status: :see_other, notice: "Conversation was successfully destroyed."
  end

  private

  def set_conversation
    @conversation = Conversations.find(params.expect(:id))
  end

  def conversation_params
    params.expect(conversation: [ :persona_id, :character_id, :name, :description ])
  end
end
