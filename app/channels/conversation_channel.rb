class ConversationChannel < ApplicationCable::Channel
  def subscribed
    if params[:conversationId].present? && Conversation.find(params[:conversationId])
      stream_from "conversation_#{params[:conversationId]}"
      current_user.update_column(:active_conversation_id, params[:conversationId])
    else
      Rails.logger.debug "\e[31mConversationChannel=>\e[0m client failed to subscribe"
      reject
    end
  end

  def receive(data)
    # Called when the client JS channel instance sends data via the channel
    Rails.logger.debug "\e[31mConversationChannel=>\e[0m broadcasted data received from JS ConversationChannel client; #{data.inspect}"
  end
  
  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    # When ConversationChannel unsubscribed, ∴ conversation-card closed, set user.active_conversation_id to nil
    current_user.update_column(:active_conversation_id, nil)
    Rails.logger.debug("\e[31mConversationChannel=>\e[0m User id no #{current_user.id} has had active_conversation set to #{current_user.active_conversation_id}.")
    Rails.logger.debug("\e[31mConversationChannel=>\e[0m client has unsubscribed")
  end

end
