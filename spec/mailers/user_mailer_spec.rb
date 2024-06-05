require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  
  describe "welcome_email" do
    let(:user) { create(:user) }
    let(:mail) { UserMailer.with(user_id: user.id).welcome_email }
    
    it "renders the headers" do
      expect(mail.subject).to include("Welcome to Fakebook")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["hello@bibble.com"])
    end

    it "renders the body" do
      expect(mail.html_part.body.encoded).to include("<p>Hi <span style=\"font-weight: bold;\">#{user.username}</span>" +
      ", thanks for signing up, it's good to have you here.</p>")
    end
  end  
end

RSpec.describe Users::RegistrationsController, type: :controller do
  include ActiveJob::TestHelper

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'POST to #create' do
    let(:user_params) { attributes_for(:user) }

    it "enqueues the welcome email after user creation" do
      expect {
        post :create, params: { user: user_params }
      }.to have_enqueued_job.on_queue('default')
    end
  end
end

