class ConversationChannel < ApplicationCable::Channel
  def subscribed
    stream_from "conversation_#{params[:conversationId]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    puts "Client has unsubscribed from conversation channel."
  end

end
