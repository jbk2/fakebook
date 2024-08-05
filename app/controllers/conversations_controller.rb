# require 'conversation_service'
class ConversationsController < ApplicationController
  
  # action called from either:
  # 1) convo index dropdown in navbar, ∴ convo exists, ID is known, ∴ ID sent via params
  # 2) users#show where convo may not exist, ∴ #find_or_create_conversation called, then
  # conversations#show called with :conversation_id key/value as an argument to method.
  def open_conversation_card(conversation_id = nil)
    conversation_id ||= params[:id]
    @conversation = Conversation.find(conversation_id)
    
    # set active_conversation_id current_user & mark all messages' read_by_recipient as true
    @conversation.messages.where.not(user_id: current_user.id).each(&:mark_as_read_by_recipient)
    current_user.update_column(:active_conversation_id, @conversation.id)

    # session var used to keep conversation-card rendered & in view on view chnages
    session[:active_conversation_id] = @conversation.id
    Rails.logger.info("Active conversation session variable set to; #{session[:active_conversation_id]}")

    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: [
          # close conversations dropdown
          # 
          turbo_stream.replace('conversation-card', partial: 'conversations/conversation'),
          turbo_stream.replace("conversations",
          partial: 'conversations/conversations', locals: { conversations: current_user.conversations })
        ]
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
    Rails.logger.info("Checking for unread messages for this user_id: #{user.id}")
    unread_messages = user.conversations.any? do |conversation|
      conversation.messages.where.not(user_id: user.id).unread_by_recipient.any?
    end
    Rails.logger.info("\e[31m########Any unread messages? #{unread_messages}\e[0m]")
    unread_messages
  end

end