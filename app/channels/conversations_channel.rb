class ConversationsChannel < ApplicationCable::Channel

  def subscribed
    if params[:currentUserId].present? && User.find(params[:currentUserId])
      stop_all_streams
      stream_from "conversations_#{params[:currentUserId]}"
      Rails.logger.debug("\e[31mConversationsChannel\e[0m subscribed to user; #{params[:currentUserId]} scoped stream")
    else
      Rails.logger.debug("\e[31mConversationsChannel\e[0m client failed to subscribe, with params[:currentUserId]; #{params[:currentUserId]} scoped stream")
      reject
    end
  end

  def receive(data)
    # Called when the client JS channel instance sends data via the channel
    Rails.logger.debug "\e[31mConversationsChannel=>\e[0m broadcasted data received from JS ConversationsChannel client; #{data.inspect}"
  end
  
  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    stop_all_streams
    Rails.logger.debug("\e[31mConversationChannel=>\e[0m client has unsubscribed")
  end

end
