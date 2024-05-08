class MessagesController < ApplicationController
  def create
    sender_id = current_user.id
    recipient_id = params[:message][:recipient_id]
    conversation = find_or_create_conversation(sender_id, recipient_id)
    @message = conversation.messages.build(message_params.merge(user: current_user))

    if @message.save
      respond_to do |format|
        format.turbo_stream {
          # not required as being updated by Conversation ActionCable Channel
          # turbo_stream.append("conversation-#{@message.conversation_id}-card-messages", partial: "messages/message", locals: { message: @message }),
          render turbo_stream: turbo_stream.replace("message-input",
              '<input id="message-input" class="bg-slate-100 rounded-full border-none text-xs w-full" type="text" name="message[body]">')
        }
        format.html { redirect_to root_path }
      end
    else
      format.html { redirect_to root_path, status: :unprocessable_entity }
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
