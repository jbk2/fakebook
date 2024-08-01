# == Schema Information
#
# Table name: messages
#
#  id                :bigint           not null, primary key
#  body              :string
#  user_id           :bigint           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  conversation_id   :bigint           not null
#  read_by_recipient :boolean          default(FALSE)
#
require 'rails_helper'

RSpec.describe Message, type: :model do
  
  let(:user_1) { FactoryBot.create(:user) }
  let(:user_2) { FactoryBot.create(:user) }
  let(:conversation) { FactoryBot.create(:conversation, participant_one: user_1, participant_two: user_2) }
  let(:message) { FactoryBot.create(:message, user: user_1, conversation: conversation) }

  before do
    ActiveJob::Base.queue_adapter = :test
  end

  describe 'validations & associations' do

    context 'with all associations and attributes ' do
      it "should be valid" do
        expect(message).to be_valid
      end
    end
    
    context 'with missing attributes' do
      it 'should always have a body' do
        message.body = nil
        expect(message).to_not be_valid
        expect(message.errors[:body]).to include("can't be blank")
      end

      it 'should always belong to a user' do
        message.user = nil
        expect(message).to_not be_valid
        expect(message.errors[:user]).to include("must exist")
      end
      
      it 'should always belong to a conversation' do
        message.conversation = nil
        expect(message).to_not be_valid
        expect(message.errors[:conversation]).to include("must exist")
      end
    end

  end

  describe 'after_create callback' do
    it 'should queue a job to broadcast the message' do
      expect {
        message
      }.to have_enqueued_job(BroadcastMessageJob)
    end
  end
end
