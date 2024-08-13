require 'rails_helper'
include ActiveJob::TestHelper

RSpec.describe UpdateMessageNotificationJob, type: :job do
  let(:user_1) { FactoryBot.create(:user) }
  let(:user_2) { FactoryBot.create(:user) }
  let(:conversation) { FactoryBot.create(:conversation, participant_one: user_1, participant_two: user_2) }
  let(:message) { FactoryBot.create(:message, user: user_1, conversation: conversation) }

  describe '#perform' do

    context 'when recipient does not have conversation card open' do
      it 'updates the notification state for the recipient' do
        expect(user_2.active_conversation_id).to be_nil
        expect(ActionCable.server).to receive(:broadcast).with("notifications_#{user_2.id}", {
          action: 'new_message_notification',
          recipient_id: user_2.id
        })
        UpdateMessageNotificationJob.perform_now(message.id)
      end
    end
    
    context 'when recipient does have conversation card open' do
      it "marks all of the conversation's messages as read by the recipient" do
        message # call the lazily evaluated let(:message) so that it creates the message for us to test
        expect(conversation.messages.count).to eq(1)
        conversation.messages.each do |message|
          puts "I am running"
          expect(message.read_by_recipient).to be(false)
        end
        
        expect(conversation.participant_two.active_conversation_id).to be(nil)
        user_2.update_column(:active_conversation_id, message.conversation.id)
        expect(conversation.participant_two.active_conversation_id).to be(conversation.id)
        
        UpdateMessageNotificationJob.perform_now(message.id)
        expect(conversation.messages.count).to eq(1)
        
        conversation.messages.each do |updated_message|
          updated_message.reload
          expect(updated_message.read_by_recipient).to be(true)
        end
        
        expect(conversation.messages.count).to eq(1)
      end
    end
    
    it 'never updates the notification state for the message sender' do
      expect(ActionCable.server).not_to receive(:broadcast).with("notification_#{user_1.id}", {
        action: 'new_message_notification',
        recipient_id: user_1.id
      })

      UpdateMessageNotificationJob.perform_now(message.id)
    end
  end

end
