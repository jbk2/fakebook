class ConversationChannel < ApplicationCable::Channel
  def subscribed
    conversation = Conversation.find(params[:conversation_id])
    stream_for conversation if conversation.participants.include?(current_user)
    puts "now subscribed to and streaming from conversation.id no;#{conversation.id}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    stop_all_streams
  end

  def receive(data)
    data['sender'] = current_user
    puts "here's what data looks like #{data}"
  end
end
