module RoomScoped
  extend ActiveSupport::Concern

  included do
    before_action :set_room
  end

  private

  def set_room
    @room = Current.user.rooms.find(params[:room_id])
  end
end
