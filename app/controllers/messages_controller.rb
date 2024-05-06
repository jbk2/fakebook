# Currently unused due to JS capture of message form data, sending directly to consumer
# subscriptions and broadcasting from client's message_channel received(data) method.
class MessagesController < ApplicationController
  def create
    conversation = find_or_create_conversation(current_user.id, params[recipient_id])
    @message = conversation.messages.build(message_params.merge(user: current_user))

    if @message.save
      broadcast_message
      render json: @message.as_json(include: :user)
    else
      render json: { errors: @message.errors.full_messages }, status: :unprocessable_entity
    end

    # ActionCable.server.broadcast("message:#{current_user.id}", @message.as_json(include: :user))
    # ActionCable.server.broadcast("message:#{@message.recipient_id}", @message.as_json(include: :user))
  end

  private
  def message_params
    params.require(:message).permit(:body, :recipient_id)
  end

  def find_or_create_conversation
    conversation = Conversation.between(current_user.id, recipient_id).first
    conversation ||= Conversation.create(participant_one_id: current_user.id, participant_two_id: recipient_id)
  end

  def broadcast_message
    ActionCable.server.broadcast("message:#{current_user.id}", @message.as_json(include: :user))
    ActionCable.server.broadcast("message:#{recipient_id}", @message.as_json(include: :user))
  end


end
