require 'rails_helper'

RSpec.describe NotificationsChannel, type: :channel do
  let(:user) { create(:user) }  # Ensure FactoryBot is correctly set up to create users

  before do
    stub_connection current_user: user
  end

  describe 'subscription' do
    it 'subscribes to a stream when provided a valid user ID' do
      subscribe(currentUserId: user.id)
      expect(subscription).to be_confirmed
      expect(subscription).to have_stream_from("notifications_#{user.id}")
    end

    it 'rejects subscription when no currentUserId is provided' do
      subscribe(currentUserId: nil)
      expect(subscription).to be_rejected
    end

    it 'rejects subscription when the user does not exist' do
      subscribe(currentUserId: 99999) # Assuming this ID does not exist
      expect(subscription).to be_rejected
    end
  end

  describe 'unsubscription' do
    it 'stops all streams when unsubscribed' do
      subscribe(currentUserId: user.id)
      expect(subscription).to be_confirmed
      expect(subscription).to have_stream_from("notifications_#{user.id}")

      subscription.unsubscribe_from_channel
      expect(subscription).not_to have_streams
    end
  end

end
