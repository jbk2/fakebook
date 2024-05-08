class ConversationsController < ApplicationController
  def show
    @conversation = Conversation.find(params[:id])
    
    if @conversation.participants.include?(current_user)
      session[:active_conversation_id] = @conversation.id
      Rails.logger.info("Active conversation session variable set to; #{session[:active_conversation_id]}")
    end

    respond_to do |format|
      format.html { redirect_to root_path }
      format.turbo_stream {
        render turbo_stream: turbo_stream.replace('conversation-card', partial: 'conversations/conversation')
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