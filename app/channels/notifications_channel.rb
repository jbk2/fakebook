class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "notification_#{current_user.id}"
  end

  def receive(data)
    # Called when the client JS channel instance sends data via the channel
    puts "Broadcasted data received from JS client channel instance: #{data.inspect}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    puts "Client has unsubscribed from the Notification channel."
  end
end
