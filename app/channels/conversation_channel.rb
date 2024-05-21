class ConversationChannel < ApplicationCable::Channel
  def subscribed
    if params[:conversationId].present? && Conversation.find(params[:conversationId])
      stream_from "conversation_#{params[:conversationId]}"
    else
      Rails.logger.debug "Client attempted to subscribe to a conversation channel without a valid conversation_id"
      reject
    end
  end

  def receive(data)
    # Called when the client JS channel instance sends data via the channel
    puts "Broadcasted data received from JS client channel instance: #{data.inspect}"
  end
  
  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    puts "Client has unsubscribed from conversation channel."
  end

end
