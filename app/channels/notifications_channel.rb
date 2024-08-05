class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "notification_#{current_user.id}"
    Rails.logger.debug("\e[31mNotificationsChannel\e[0m subscribed to user; #{params[:currentUserId]} scoped stream")
  end

  def receive(data)
    # Called when the client JS channel instance sends data via the channel
    Rails.logger.debug "\e[31mNotificationsChannel=>\e[0m broadcasted data received from JS NotificationsChannel client; #{data.inspect}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    Rails.logger.debug("\e[31mNotificationsChannel=>\e[0m client has unsubscribed")
  end
end
