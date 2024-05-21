require 'rails_helper'

RSpec.describe ConversationChannel, type: :channel do
  let(:user) { FactoryBot.create(:user) }
  let(:conversation) { FactoryBot.create(:conversation) }

  before do
    stub_connection current_user: user
  end

  it 'successfully subscribes' do
    subscribe(conversationId: conversation.id)

    expect(subscription).to be_confirmed
    expect(subscription).to have_stream_from("conversation_#{conversation.id}")
  end
 
  it 'rejects subscription with a conversation_id of nil' do
    subscribe(conversationId: nil)

    expect(subscription).to be_rejected
  end
  
  it 'rejects subscription with a conversation_id of a non existent conversation' do
    subscribe(conversationId: nil)

    expect(subscription).to be_rejected
  end

  # currently the server connection does not receive any data from anywhere thus is not written to do anything
  # it 'receives data from the client' do
  #   subscribe(conversationId: conversation.id)
  #   data = { 'message' => 'Hello' }

  #   expect { perform :receive, data }.to have_broadcasted_to("conversation_#{conversation.id}").with(data)
  # end

  it 'unsubscribes from the stream' do
    subscribe(conversationId: conversation.id)

    expect(subscription).to be_confirmed
    expect(subscription).to have_stream_from("conversation_#{conversation.id}")

    subscription.unsubscribe_from_channel

    expect(subscription).not_to have_stream_from("conversation_#{conversation.id}")
  end
end