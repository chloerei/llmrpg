class Rooms::Members::PlaysController < Rooms::Members::BaseController
  def create
    @room.members.where(playing: true).update_all(playing: false)
    @member.update(playing: true)
    redirect_to room_members_path(@room), notice: "You are now playing as #{@member.character.name}."
  end

  def destroy
    @member.update(playing: false)
    redirect_to room_members_path(@room), notice: "You are no longer playing as #{@member.character.name}."
  end
end
