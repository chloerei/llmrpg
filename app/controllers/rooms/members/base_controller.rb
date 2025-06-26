class Rooms::Members::BaseController < Rooms::BaseController
  before_action :set_member

  private

  def set_member
    @member = @room.members.find(params[:member_id])
  end
end
