# require 'conversation_service'
class ConversationsController < ApplicationController
  before_action :ensure_ajax_request, only: [:check_unread, :mark_all_read]
  before_action :ensure_turbo_request, only: [:open_conversation_card]

  def open_conversation_card
    conversation_id = params[:id]
    @conversation = Conversation.find(conversation_id)
    
    # mark all current_user's messages as read & set their active_conversation_id
    @conversation.messages.where.not(user_id: current_user.id).each(&:mark_as_read_by_recipient)
    current_user.update_column(:active_conversation_id, @conversation.id)
    Rails.logger.debug("####### Current user id user is; #{current_user.id}")
    Rails.logger.debug("####### Current users active_conversation_id is; #{current_user.active_conversation_id}")

    # session var used to keep conversation-card rendered & in view on view chnages
    session[:active_conversation_id] = @conversation.id
    Rails.logger.debug("\e[1;32mActive conversation session variable set to;\e[0m] #{session[:active_conversation_id]}")

    # if conversations frame is open close it
    ActionCable.server.broadcast("conversations_#{current_user.id}", {
      close_conversations_frame: true
    })

    @message = @conversation.messages.build(user: current_user)

    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: [
          turbo_stream.replace('conversation-card', partial: 'conversations/conversation')#,
          # turbo_stream.replace("conversations",
          # partial: 'conversations/conversations', locals: { conversations: current_user.conversations })
        ]
      }
      format.html { redirect_to root_path } # because there's no full html view page for a conversation
    end
  end

  def find_or_create_conversation
    @conversation = ConversationService.find_or_create_conversation(current_user.id, params[:recipient_id])

    unless @conversation.persisted?
      Rails.logger.error("Conversation creation failed: #{@conversation.errors.full_messages.to_sentence}")
      return nil
    end
    
    params[:id] = @conversation.id
    open_conversation_card
  end

  def close_conversation_card
    session[:active_conversation_id] = nil

    # set active_conversation_id to nil for current_user
    current_user.update_column(:active_conversation_id, nil)

    # empty the conversation-card turbo-frame
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace('conversation-card',
        '<turbo-frame id="conversation-card"></turbo-frame>')}
      format.html { redirect_to root_path }
    end
  end

  def check_unread
    user_id = params[:user_id]
    user = User.find(user_id)
    render json: { unread_messages: any_unread_messages?(user) }
  end

  def mark_all_read
    user_id = params[:user_id]
    user = User.find(user_id)
    user.conversations.each do |conversation|
      conversation.messages.where.not(user_id: user.id).each(&:mark_as_read_by_recipient)
    end
    render json: { success: true, message: "All messages marked as read." }, status: :ok
  end

  private
  def conversation_params
    params.require(:conversation).permit(:participant_one_id, :participant_two_id)
  end

  def any_unread_messages?(user)
    user.conversations.includes(:messages).any? do |conversation|
      conversation.messages.where.not(user_id: user.id).unread_by_recipient.any?
    end
  end

  def ensure_ajax_request
    unless request.xhr?
      Rails.logger.debug "\e[31mNon-AJAX request detected, redirecting from:\e[0m] #{request.fullpath}"
      redirect_to root_path, alert: "Endpoint only accessible via AJAX"
    end
  end

  def ensure_turbo_request
    unless request.headers['Turbo-Frame'] || request.headers['accept'].include?('text/vnd.turbo-stream.html')
      redirect_to root_path, alert: "Endpoint only accessible via Turbo"
    end
  end  

end