class ConversationService

  def self.find_or_create_conversation(sender_id, recipient_id)
    begin
      Conversation.between(sender_id, recipient_id).first_or_create do |conversation|
        conversation.participant_one_id = sender_id
        conversation.participant_two_id = recipient_id
      end
    rescue => e
      conversation = e.record
      Rails.logger.error("Failed to create or find Conversation: #{e.message}")
      nil
    end
  end

end