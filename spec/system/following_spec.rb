require 'rails_helper'

describe 'Following', type: :system do
  before { driven_by(:selenium_chrome_headless) }

  let!(:users) { create_list(:user, 4) }
  let!(:signed_in_user) { users.shift }
  let!(:followed_user) { users[0] }
  let!(:posts) { create_list(:post, 1, user: followed_user) }

  before do
    sign_in(signed_in_user)
  end
  
  context 'from users#index' do
    it 'a logged in user can follow another user' do
      visit users_path
      find("#follow_action_button_#{followed_user.id}").click
      expect(page).to have_content("You are now following #{followed_user.username}")
      expect(page).to have_css("#follow_action_button_#{followed_user.id}", text: "Un-Follow")
    end
    
    it 'a logged in user can un-follow a another user' do
      visit users_path
      find("#follow_action_button_#{followed_user.id}").click
      expect(page).to have_content("You are now following #{followed_user.username}")
      expect(page).to have_css("#follow_action_button_#{followed_user.id}", text: "Un-Follow")
      
      find("#follow_action_button_#{followed_user.id}").click
      expect(page).to have_content("You are no longer following #{followed_user.username}")
      expect(page).to have_css("#follow_action_button_#{followed_user.id}", text: "Follow")
    end
  end

  context 'from posts#index' do
    it 'allows a user to be unfollowed from post cards header actions' do
      create(:follow, follower: signed_in_user, followed: users[0])
      visit user_posts_path(signed_in_user)
      expect(page).to have_css("#follow_action_button_#{followed_user.id}_#{posts[0].id}", text: /^Un-Follow$/, count: 1)
      find("#follow_action_button_#{followed_user.id}_#{posts[0].id}").click
      expect(page).to have_css("#follow_action_button_#{followed_user.id}_#{posts[0].id}", text: /^Follow$/)
    end
  end

  private
  def sign_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'
  end
end