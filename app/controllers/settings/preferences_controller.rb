class Settings::PreferencesController < ApplicationController
  def show
  end

  def update
    if Current.user.update(preferences_params)
      redirect_to settings_preference_path, notice: t(".success")
    else
      flash.now[:alert] = t(".failure")
      render :show
    end
  end

  private

  def preferences_params
    params.require(:user).permit(:locale)
  end
end
