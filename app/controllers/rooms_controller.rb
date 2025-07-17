class RoomsController < ApplicationController
  before_action :set_room, only: %i[ show edit update destroy ]

  def index
    @pagy, @rooms = pagy(Current.user.rooms.order(id: :desc))
  end

  def show
    @conversation = if params[:conversation_id]
      @room.conversations.find(params[:conversation_id])
    else
      @room.conversations.order(id: :desc).first || @room.conversations.create(user: @room.user)
    end

    @pagy, @messages = pagy(@conversation.messages.order(id: :desc))
  end

  def new
    @room = Current.user.rooms.new
  end

  def edit
  end

  def create
    @room = Current.user.rooms.new(room_params)

    if @room.save
      redirect_to @room, notice: t(".success")
    else
      flash.now[:alert] = t(".failure")
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @room.update(room_params)
      redirect_to @room, notice: t(".success")
    else
      flash.now[:alert] = t(".failure")
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @room.destroy!

    redirect_to rooms_path, status: :see_other, notice: "Room was successfully destroyed."
  end

  private

  def set_room
    @room = Current.user.rooms.find(params.expect(:id))
  end

  def room_params
    params.require(:room).permit(:name, :prompt)
  end
end
