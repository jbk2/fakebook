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
      renderer = double('renderer')
      allow(ApplicationController.renderer).to receive(:new).and_return(renderer)

      expect(renderer).to receive(:render).with(partial: 'messages/message', locals: { message: message }).and_return('rendered message')
      expect(renderer).to receive(:render).with(partial: 'conversations/conversations', locals: { conversations: user_1.conversations, current_user: user_1 }).and_return('rendered conversations for user 1')
      expect(renderer).to receive(:render).with(partial: 'conversations/conversations', locals: { conversations: user_2.conversations, current_user: user_2 }).and_return('rendered conversations for user 2')

      expect(ActionCable.server).to receive(:broadcast).with("conversation_#{conversation.id}", {
        conversation_id: conversation.id,
        message_html: 'rendered message'
      })
      expect(ActionCable.server).to receive(:broadcast).with("conversations_#{user_1.id}", {
        conversations_html: 'rendered conversations for user 1'
      })
      expect(ActionCable.server).to receive(:broadcast).with("conversations_#{user_2.id}", {
        conversations_html: 'rendered conversations for user 2'
      })

      perform_enqueued_jobs do
        BroadcastMessageJob.perform_later(message, user_1.id, conversation.id)
      end
    end
  end
end
