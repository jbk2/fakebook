class BroadcastMessageJob < ApplicationJob
  queue_as :default

  def perform(message, sender_id, conversation_id)
    renderer = ApplicationController.renderer.new
    rendered_message_html = renderer.render(partial: "messages/message", locals: { message: message })
    
    sender = User.find(sender_id)
    senders_conversations = sender.conversations
    conversation = Conversation.find(conversation_id)
    recipient = conversation.other_participant(sender)
    recipients_conversations = recipient.conversations
    
    senders_conversations_html = renderer.render(partial: "conversations/conversations",
      locals: { conversations: senders_conversations, current_user: sender })
    recipients_conversations_html = renderer.render(partial: "conversations/conversations",
      locals: { conversations: recipients_conversations, current_user: recipient })

    ActionCable.server.broadcast("conversation_#{conversation_id}", {
      message_html: rendered_message_html,
      conversation_id: conversation_id
    })
    
    ActionCable.server.broadcast("conversations_#{recipient.id}", {
      conversations_html: recipients_conversations_html
    })
    
    ActionCable.server.broadcast("conversations_#{sender.id}", {
      conversations_html: senders_conversations_html
    })

  end
end