class Settings::Account::EmailsController < ApplicationController
  def show
  end

  def update
    if Current.user.update(email_params.with_defaults(password_challenge: ""))
      redirect_to settings_account_email_path, notice: t("settings.account.emails.update.success")
    else
      flash.now[:alert] = t("settings.account.emails.update.failure")
      render :show, status: :unprocessable_entity
    end
  end

  private

  def email_params
    params.expect(user: [ :email, :password_challenge ])
  end
end
