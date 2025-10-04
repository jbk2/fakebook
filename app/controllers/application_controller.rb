class ApplicationController < ActionController::Base
  # include CurrentUserExtensions
  include Pagy::Backend
  helper DeviseHelpers # Include the DeviseHelpers 'controller & action identification' module

  before_action :authenticate_user!, :limit_session_user_return_to#, :debug_session
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

  def debug_session
    Rails.logger.info "Session size: #{session.to_hash.to_s.bytesize} bytes"
    Rails.logger.info "Session keys: #{session.to_hash.keys.inspect}"
  end

  def limit_session_user_return_to
    key = "user_return_to"
    val = session[key]
    return unless val.is_a?(String)
  
    if val.bytesize > 1024
      session.delete(key)
    end
  end
end
