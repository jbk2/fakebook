class UserMailer < ApplicationMailer

  def welcome_email
    @user = User.find(params[:user_id])
    @username = @user.username
    attachments.inline["fakebook_logo.png"] = File.read("#{Rails.root}/app/assets/images/icons/facebook.png")
    puts "@username is #{@username}"

    mail to: @user.email, subject: "Welcome to Fakebook 👋🏻", reply_to: "james@bibble.com"
  end
end
