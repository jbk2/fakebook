require 'rails_helper'

RSpec.describe "Conversations", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/conversations/show"
      expect(response).to have_http_status(:success)
    end
  end

end
