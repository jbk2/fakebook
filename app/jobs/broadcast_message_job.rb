class BroadcastMessageJob < ApplicationJob
  queue_as :default

  def perform(message)
    rendered_message = ApplicationController.renderer.render(partial: "messages/message", locals: { message: message })
    image_url = Rails.application.routes.url_helpers.rails_blob_url(message.user.profile_photo, host: 'localhost:3000')

    ActionCable.server.broadcast("conversation_#{message.conversation_id}", {
      message_html: rendered_message,
      image_url: image_url
    })
  end

end
