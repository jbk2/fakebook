require 'rails_helper'

RSpec.describe ApplicationCable::Connection, type: :channel do
  let(:user) { FactoryBot.create(:user) }

  before do
    allow_any_instance_of(ActionCable::Connection::Base).to receive(:env).and_return('warden' => double("Warden", user: user))
  end

  context 'with a verified user' do
    it 'successfully connects' do
      connect "/cable"

      expect(connection.current_user).to eq(user)
    end
  end

  context 'with an unauthorized user' do
    it 'rejects connection' do
      allow_any_instance_of(ActionCable::Connection::Base).to receive(:env).and_return('warden' => double("Warden", user: nil))

      expect { connect "/cable" }.to have_rejected_connection
    end
  end
end
