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
    let(:conversation) { FactoryBot.create(:conversation, participant_one: user_1, participant_two: user_2) }

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

  end
end
