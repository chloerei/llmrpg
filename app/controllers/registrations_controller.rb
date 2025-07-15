class RegistrationsController < ApplicationController
  layout "application"

  allow_unauthenticated_access

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.locale = I18n.locale

    if @user.save
      start_new_session_for(@user)
      redirect_to after_authentication_url
    else
      flash.now[:alert] = t(".failure")
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
