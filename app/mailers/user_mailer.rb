class UserMailer < ApplicationMailer

  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Sample App account activation"
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Sample App password reset request"
  end
end
