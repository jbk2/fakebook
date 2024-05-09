class ConversationsController < ApplicationController
  def create
    @recipient_id = params[:recipient_id]
  
    if Conversation.between(current_user.id, @recipient_id).present?
      @conversation = Conversation.between(current_user.id, @recipient_id).first
    else
      @conversation = current_user.conversations.build(participant_one_id: current_user.id,
        participant_two_id: @recipient_id)
      if @conversation.save
        Rails.logger.info("Active conversation session variable set to; #{session[:active_conversation_id]}")
      else
        Rails.logger.error("Conversation creation failed: #{@conversation.errors.full_messages.to_sentence}")
        return
      end
    end
    
    session[:active_conversation_id] = @conversation.id

    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: turbo_stream.replace('conversation-card', partial: 'conversations/conversation')
      }
      format.html { redirect_to root_path }
    end
  end
  
  def show
    @conversation = Conversation.find(params[:id])
    
    if @conversation.participants.include?(current_user)
      session[:active_conversation_id] = @conversation.id
      Rails.logger.info("Active conversation session variable set to; #{session[:active_conversation_id]}")
    end

    respond_to do |format|
      format.html { redirect_to root_path }
      format.turbo_stream {
        render turbo_stream: [ turbo_stream.replace('conversation-card', partial: 'conversations/conversation'),
          turbo_stream.replace("conversations",
          partial: 'conversations/conversations', locals: { conversations: current_user.conversations })]
        }
    end
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