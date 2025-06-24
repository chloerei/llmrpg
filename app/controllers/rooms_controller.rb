class RoomsController < ApplicationController
  before_action :set_room, only: %i[ show edit update destroy ]

  def index
    @rooms = Current.user.rooms.order(id: :desc)
  end

  def show
    @conversations = @room.conversations.order(id: :desc)
  end

  def new
    @room = Room.new
  end

  def edit
  end

  def create
    @room = Current.user.rooms.new(room_params)

    if @room.save
      redirect_to @room, notice: "Room was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @room.update(room_params)
      redirect_to @room, notice: "Room was successfully updated."
    else
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
    params.require(:room).permit(:name, :description, :character_list)
  end
end
