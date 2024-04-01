require 'rails_helper'

describe 'Authentication', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:post) { FactoryBot.create(:post, user: user) }

  context 'when user is not logged in' do
    context 'posts#index' do
      it 'redirects to the login page' do
        get user_posts_path(user)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
    
    context 'users#index' do
      it 'redirects to the login page' do
        get users_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
    
    context 'users#show' do
      it 'redirects to the login page' do
        get user_path(user)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
  

  context 'when user is logged in' do
    before do
      sign_in user
    end

    it 'root path successfully renders the user_posts_path' do
      get root_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Whats on your mind #{user.username}?")

    end
  end
  
end