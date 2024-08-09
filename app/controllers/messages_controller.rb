# require 'conversation_service'
class MessagesController < ApplicationController

  before_action :set_conversation

  def create
    @message = @conversation.messages.build(message_params.merge(user: current_user))

    if @message.save
      respond_to do |format|
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace("message-input",
            '<input id="message-input" class="bg-slate-100 rounded-full h-8 pl-4 border-none text-xs w-full" type="text" name="message[body]">')
        }
        format.html { redirect_to root_path }
      end
    else
      redirect_to root_path, status: :unprocessable_entity
    end
  end

  private
  def message_params
    params.require(:message).permit(:body)
  end

  def set_conversation
    @conversation = ConversationService.find_or_create_conversation(current_user.id, params[:message][:recipient_id])
  end

end
