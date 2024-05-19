class UserMailer < ApplicationMailer

  def welcome_email
    @user = params[:user]
    @username = @user.username

    mail to: @user.email, subject: "Welcome to Fakebook"
  end
end
