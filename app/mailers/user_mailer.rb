class UserMailer < ApplicationMailer

  def welcome_email
    @user = User.find(params[:user_id])
    @username = @user.username
    puts "@username is #{@username}"

    mail to: @user.email, subject: "Welcome to Fakebook"
  end
end
