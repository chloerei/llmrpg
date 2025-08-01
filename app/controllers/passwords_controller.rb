class PasswordsController < ApplicationController
  allow_unauthenticated_access
  before_action :set_user_by_token, only: %i[ edit update ]

  layout "application"

  def new
  end

  def create
    if user = User.find_by(email: params[:email])
      UserMailer.reset_password(user).deliver_later
    end

    redirect_to new_session_path, notice: t(".email_sent")
  end

  def edit
  end

  def update
    if @user.update(params.permit(:password, :password_confirmation))
      redirect_to new_session_path, notice: t(".success")
    else
      flash.now[:alert] = t(".failure")
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user_by_token
    @user = User.find_by_password_reset_token!(params[:token])
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    redirect_to new_password_path, alert: t(".invalid_token")
  end
end
