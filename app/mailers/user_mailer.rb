class UserMailer < ApplicationMailer
  def reset_password(user)
    @user = user
    mail subject: "Reset your password", to: user.email
  end
end
