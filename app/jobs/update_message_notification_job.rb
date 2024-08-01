class UpdateMessageNotificationJob < ApplicationJob
  queue_as :default

  def perform(message_id, conversation_id)
    sender = Message.find(message_id).user
    recipient = Conversation.find(conversation_id).other_participant(sender)

    unless recipient.active_conversation_id == conversation_id
      update_notification_state(recipient)
    end
  end

  private

  def update_notification_state(user)
    unread_messages = user.messages.where(read_by_recipient: false).any?
    ActionCable.server.broadcast("notification_#{user.id}", {
      action: unread_messages ? 'add_notification' : 'remove_notification'
    })
  end

end
