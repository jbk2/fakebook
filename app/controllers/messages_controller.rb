# Currently unused due to JS capture of message form data, sending directly to consumer
# subscriptions and broadcasting from client's message_channel received(data) method.

ActionCable broadcasting 
class MessagesController < ApplicationController
  def create
    @message = current_user.messages.build(message_params)
    @message.save
    # ActionCable.server.broadcast('message', @message.as_json(include: :user))
  end

  private
  def message_params
    params.require(:message).permit(:body, :message_recipient_id)
  end

end
