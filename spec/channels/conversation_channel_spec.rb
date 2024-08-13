require 'rails_helper'

RSpec.describe ConversationChannel, type: :channel do
  let(:user1) { FactoryBot.create(:user) }
  let(:user2) { FactoryBot.create(:user) }
  let(:conversation) { FactoryBot.create(:conversation, participant_one: user1, participant_two: user2) }

  before do
    # Assuming we're testing the connection from user1's perspective
    stub_connection current_user: user1
  end

  describe 'Subscription' do
    context 'with valid parameters' do
      it 'successfully subscribes to a stream and updates user active conversation' do
        subscribe(conversationId: conversation.id)

        expect(subscription).to be_confirmed
        expect(subscription).to have_stream_from("conversation_#{conversation.id}")
        expect(user1.reload.active_conversation_id).to eq(conversation.id)
      end
    end

    context 'with invalid parameters' do
      it 'rejects subscription if conversationId is nil' do
        subscribe(conversationId: nil)

        expect(subscription).to be_rejected
      end

      it 'rejects subscription if the conversation does not exist' do
        non_existent_conversation_id = 99999
        subscribe(conversationId: non_existent_conversation_id)

        expect(subscription).to be_rejected
      end
    end
  end

  describe 'Unsubscribing' do
    it 'cleans up the streams and resets user active conversation when disconnected' do
      subscribe(conversationId: conversation.id)

      expect(subscription).to be_confirmed
      expect(subscription).to have_stream_from("conversation_#{conversation.id}")

      subscription.unsubscribe_from_channel

      expect(subscription).not_to have_stream_from("conversation_#{conversation.id}")
      expect(user1.reload.active_conversation_id).to be_nil
    end
  end
end
