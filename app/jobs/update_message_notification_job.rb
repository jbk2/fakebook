class UpdateMessageNotificationJob < ApplicationJob
  queue_as :default

  def perform(message_id)
    message = Message.find(message_id)
    sender = message.user
    conversation = message.conversation
    recipient = conversation.other_participant(sender)

    # Only recipient gets update & only if they don't have conversation-card open.
    if recipient.active_conversation_id == conversation.id
      conversation.messages.where.not(user_id: recipient.id).each(&:mark_as_read_by_recipient)
    else
      update_notification_state(recipient)
    end
  end

  private

  def update_notification_state(recipient)
    ActionCable.server.broadcast("notifications_#{recipient.id}", {
      action: 'new_message_notification',
      recipient_id: recipient.id
    })
  end

end