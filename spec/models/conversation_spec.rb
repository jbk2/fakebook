# == Schema Information
#
# Table name: conversations
#
#  id                 :bigint           not null, primary key
#  participant_one_id :bigint           not null
#  participant_two_id :bigint           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
require 'rails_helper'

RSpec.describe Conversation, type: :model do
  describe 'validations & associations' do
    let(:user_1) { FactoryBot.create(:user) }
    let(:user_2) { FactoryBot.create(:user) }
    let!(:conversation) do
      FactoryBot.create(:conversation, participant_one: user_1, participant_two: user_2)
    end

    context 'with all associations and attributes ' do
      it "should be valid" do
        expect(conversation).to be_valid
      end
    end

    context 'with missing attributes' do
      it 'should always have a participant_one' do
        conversation.participant_one = nil
        expect(conversation).to_not be_valid
        expect(conversation.errors[:participant_one]).to include("must exist")
      end

      it 'should always have a participant_two' do
        conversation.participant_two = nil
        expect(conversation).to_not be_valid
        expect(conversation.errors[:participant_two]).to include("must exist")
      end
    end

    describe 'where a previous conversation had the same two users' do
      it 'should not be valid' do
        new_conversation = FactoryBot.build(:conversation, participant_one: user_2, participant_two: user_1)
        expect(new_conversation).not_to be_valid
        expect(new_conversation.errors[:base]).to include(
          "a conversation between #{new_conversation.participant_two_id} & #{new_conversation.participant_one_id} already exists; conversation_id# #{conversation.id}")
      end
    end

  end
end
