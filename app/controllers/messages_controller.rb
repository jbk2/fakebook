class MessagesController < ApplicationController
  def create
    sender_id = current_user.id
    recipient_id = params[:message][:recipient_id]
    conversation = find_or_create_conversation(sender_id, recipient_id)
    @message = conversation.messages.build(message_params.merge(user: current_user))

    if @message.save
      render json: @message.as_json(include: :user)
    else
      render json: { errors: @message.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private
  def message_params
    params.require(:message).permit(:body, :conversation_id)
  end

  def find_or_create_conversation(sender_id, recipient_id)
    conversation = Conversation.between(sender_id, recipient_id).first
    conversation ||= Conversation.create(participant_one_id: sender_id, participant_two_id: recipient_id)
    unless conversation.persisted?
      Rails.logger.error("Conversation creation failed: #{conversation.errors.full_messages.to_sentence}")
      return nil
    end
    conversation
  end

end
