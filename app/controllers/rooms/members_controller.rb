class Rooms::MembersController < Rooms::BaseController
  def index
    @members = @room.members.includes(:character).order(playing: :desc, created_at: :asc)
  end

  def new
  end

  def create
    @characters = Current.user.characters.where(id: member_params[:character_ids]).where.not(id: @room.characters.pluck(:id))

    @characters.each do |character|
      @room.members.create(character: character)
    end

    redirect_to room_members_path(@room), notice: "Members were successfully added."
  end

  def destroy
    @member = @room.members.find(params[:id])
    @member.destroy
    redirect_to room_members_path(@room), notice: "Member was successfully removed."
  end

  private

  def member_params
    params.permit(character_ids: [])
  end
end
