class ConversationChannel < ApplicationCable::Channel
  def subscribed
    stream_from "conversation_#{params[:conversationId]}"
  end

  def receive(data)
    # Called when the client JS chanel instance sends data via the channel
    puts "Data received from client: #{data}"
  end
  
  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    puts "Client has unsubscribed from conversation channel."
  end

end
