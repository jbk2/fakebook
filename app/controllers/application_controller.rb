class ApplicationController < ActionController::Base
  # include CurrentUserExtensions
  include Pagy::Backend
  helper DeviseHelpers # Include the DeviseHelpers 'controller & action identification' module

  before_action :authenticate_user!
  before_action :set_conversations_and_conversation, if: -> { user_signed_in? }

  private

  def set_conversations_and_conversation
    set_conversations
    set_conversation
  end

  def set_conversations
    @conversations = current_user.conversations
  end

  def set_conversation
    if session[:active_conversation_id]
      @conversation = Conversation.includes(participant_one: [profile_photo_attachment: :blob],
        participant_two: [profile_photo_attachment: :blob]).find(session[:active_conversation_id])
    end
  end
end
