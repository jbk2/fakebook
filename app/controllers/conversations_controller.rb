class ConversationsController < ApplicationController
  
  # action called from either:
  # 1) convo index dropdown in navbar, ∴ convo exists, ID is known, ∴ ID sent via params
  # 2) users#show where convo may not exist, ∴ #find_or_create_conversation called, then
  # conversations#show called with :conversation_id key/value as an argument to method.
  def show(options = {})
    conversation_id = options.fetch(:conversation_id, params[:id])
    @conversation = Conversation.find(conversation_id)
    
    # session var used to keep conversation-card rendered & in view on view chnages
    if @conversation.participants.include?(current_user)
      session[:active_conversation_id] = @conversation.id
      Rails.logger.info("Active conversation session variable set to; #{session[:active_conversation_id]}")
    end

    respond_to do |format|
      format.html { redirect_to root_path } # no full view page for conversation
      format.turbo_stream {
        render turbo_stream: [
          turbo_stream.replace('conversation-card', partial: 'conversations/conversation'),
          turbo_stream.replace("conversations",
          partial: 'conversations/conversations', locals: { conversations: current_user.conversations })]
        }
    end
  end

  def find_or_create_conversation
    sender_id, recipient_id = current_user.id, params[:recipient_id]
    @conversation = Conversation.between(sender_id, recipient_id).first
    if @conversation.nil?
      @conversation = Conversation.create(participant_one_id: sender_id, participant_two_id: recipient_id)
    end
    
    unless @conversation.persisted?
      Rails.logger.error("Conversation creation failed: #{@conversation.errors.full_messages.to_sentence}")
      return nil
    end

    show(conversation_id: @conversation.id)
  end

  def close_conversation_card
    session[:active_conversation_id] = nil

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace('conversation-card',
        '<turbo-frame id="conversation-card"></turbo-frame>')
      end
      format.html { redirect_to root_path }
    end
  end

end