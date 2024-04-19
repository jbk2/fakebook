class MessageChannel < ApplicationCable::Channel
  def subscribed
    stream_from "message:#{current_user.id}"
    puts "now subscribed to and streaming from; 'message:#{current_user.id}'"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    stop_all_streams
  end

  def receive(data)
    data['sender'] = current_user
    puts "here's what data looks like #{data['message[recipient_id]']}"
    # ActionCable.server.broadcast("message:#{data['message[recipient_id]']}", data)
  end
end
