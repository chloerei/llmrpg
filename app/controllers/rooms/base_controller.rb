class Rooms::BaseController < ApplicationController
  before_action :set_room

  private

  def set_room
    @room = Current.user.rooms.find(params[:room_id])
  end
end
