class BroadcastMessageJob < ApplicationJob
  queue_as :default

  def perform(message, sender_id, conversation_id)
    rendered_message = ApplicationController.renderer.render(partial: "messages/message", locals: { message: message })
    # image_url = Rails.application.routes.url_helpers.rails_blob_url(message.user.profile_photo, host: 'localhost:3000')
    sender = User.find(sender_id)
    senders_conversations = sender.conversations
    conversation = Conversation.find(conversation_id)
    recipient = conversation.other_participant(sender)
    recipients_conversations = recipient.conversations
    
    senders_conversations_html = ApplicationController.renderer.render(partial: "conversations/conversations",
      locals: { conversations: senders_conversations, current_user: sender })
    recipients_conversations_html = ApplicationController.renderer.render(partial: "conversations/conversations",
      locals: { conversations: recipients_conversations, current_user: recipient })

    ActionCable.server.broadcast("conversation_#{message.conversation_id}", {
      message_html: rendered_message,
      senders_conversations_html: senders_conversations_html,
      sender_id: sender_id,
      recipients_conversations_html: recipients_conversations_html,
      recipient_id: recipient.id
    })
  end

end
