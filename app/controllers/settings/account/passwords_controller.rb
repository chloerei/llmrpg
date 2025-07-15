class Settings::Account::PasswordsController < ApplicationController
  def show
  end

  def update
    if Current.user.update password_params.with_defaults(password_challenge: "")
      redirect_to settings_account_password_path, notice: t(".success")
    else
      flash.now[:alert] = t(".failure")
      render :show, status: :unprocessable_entity
    end
  end

  private

  def password_params
    params.expect(user: [ :password, :password_confirmation, :password_challenge ])
  end
end
