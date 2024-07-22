class BroadcastMessageJob < ApplicationJob
  queue_as :default

  def perform(message, sender_id, conversation_id)
    sender = User.find(sender_id)
    renderer = ApplicationController.renderer.new#(http_host: Rails.application.credentials[:host], https: true )
    rendered_message_html = renderer.render(partial: "messages/message", locals: { message: message })
    Rails.logger.info("Generated message HTML: #{rendered_message_html}")
    # sender_profile_photo_url = Rails.application.routes.url_helpers.rails_blob_url(sender.profile_photo, host: 'fakebook.bibble.com')
    # Rails.logger.debug("Image URL: #{sender_profile_photo_url}")
    # image_url = Rails.application.routes.url_helpers.rails_blob_url(message.user.profile_photo, host: '13.39.87.140:3000')
    senders_conversations = sender.conversations
    conversation = Conversation.find(conversation_id)
    recipient = conversation.other_participant(sender)
    recipients_conversations = recipient.conversations
    
    senders_conversations_html = renderer.render(partial: "conversations/conversations",
      locals: { conversations: senders_conversations, current_user: sender })
    recipients_conversations_html = renderer.render(partial: "conversations/conversations",
      locals: { conversations: recipients_conversations, current_user: recipient })

    ActionCable.server.broadcast("conversation_#{message.conversation_id}", {
      message_html: rendered_message_html,
      senders_conversations_html: senders_conversations_html,
      sender_id: sender.id,
      recipients_conversations_html: recipients_conversations_html,
      recipient_id: recipient.id
    })
  end

  # private

  # def secure_url_for(blob)
  #   rails_blob_url(blob, host: Rails.application.credentials[:host], protocol: 'https')
  # end

end