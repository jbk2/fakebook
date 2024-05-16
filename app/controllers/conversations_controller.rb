# require 'conversation_service'
class ConversationsController < ApplicationController
  
  # action called from either:
  # 1) convo index dropdown in navbar, ∴ convo exists, ID is known, ∴ ID sent via params
  # 2) users#show where convo may not exist, ∴ #find_or_create_conversation called, then
  # conversations#show called with :conversation_id key/value as an argument to method.
  def open_conversation_card(conversation_id = nil)
    conversation_id ||= params[:id]
    @conversation = Conversation.find(conversation_id)
    
    # session var used to keep conversation-card rendered & in view on view chnages
    session[:active_conversation_id] = @conversation.id
    Rails.logger.info("Active conversation session variable set to; #{session[:active_conversation_id]}")

    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: [
          turbo_stream.replace('conversation-card', partial: 'conversations/conversation'),
          turbo_stream.replace("conversations",
          partial: 'conversations/conversations', locals: { conversations: current_user.conversations })]
        }
      format.html { redirect_to root_path } # no full html view page for conversation
    end
  end

  def find_or_create_conversation
    @conversation = ConversationService.find_or_create_conversation(current_user.id, params[:recipient_id])

    unless @conversation.persisted?
      Rails.logger.error("Conversation creation failed: #{@conversation.errors.full_messages.to_sentence}")
      return nil
    end

    open_conversation_card(@conversation.id)
  end

  def close_conversation_card
    session[:active_conversation_id] = nil

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace('conversation-card',
        '<turbo-frame id="conversation-card"></turbo-frame>')}
      format.html { redirect_to root_path }
    end
  end

  private
  def conversation_params
    params.require(:conversation).permit(:participant_one_id, :participant_two_id)
  end


end