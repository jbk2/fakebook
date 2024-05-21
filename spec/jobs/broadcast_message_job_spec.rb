require 'rails_helper'
include ActiveJob::TestHelper

RSpec.describe BroadcastMessageJob, type: :job do

  let(:user_1) { FactoryBot.create(:user) }
  let(:user_2) { FactoryBot.create(:user) }
  let(:conversation) { FactoryBot.create(:conversation, participant_one: user_1, participant_two: user_2) }
  let(:message) { FactoryBot.create(:message, user: user_1, conversation: conversation) }

  before do
    ActiveJob::Base.queue_adapter = :test
  end

  describe '#perform' do
    it 'renders the message partial and broadcasts to the correct channel' do
      expect(ApplicationController.renderer).to receive(:render).with(partial: 'messages/message', locals: { message: message }).and_call_original
      expect(ApplicationController.renderer).to receive(:render).with(partial: 'conversations/conversations', locals: { conversations: user_1.conversations, current_user: user_1 }).and_call_original
      expect(ApplicationController.renderer).to receive(:render).with(partial: 'conversations/conversations', locals: { conversations: user_2.conversations, current_user: user_2 }).and_call_original

      expect(ActionCable.server).to receive(:broadcast).with("conversation_#{conversation.id}", {
        message_html: kind_of(String),
        senders_conversations_html: kind_of(String),
        sender_id: user_1.id,
        recipients_conversations_html: kind_of(String),
        recipient_id: user_2.id
      })

      perform_enqueued_jobs do
        BroadcastMessageJob.perform_later(message, user_1.id, conversation.id)
      end
    end
  end
end
