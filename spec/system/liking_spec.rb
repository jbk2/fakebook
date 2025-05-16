require 'rails_helper'

describe 'Liking', type: :system do
  before { driven_by(:selenium_chrome_headless) }
  let!(:users) { create_list(:user, 2) }
  let!(:signed_in_user) { users.shift }
  let!(:followed_user) { users[0] }
  let!(:follow) { create(:follow, follower: signed_in_user, followed: followed_user) }
  let!(:signed_in_user_posts) { create_list(:post, 2, user: signed_in_user) }
  let!(:followed_user_posts) { create_list(:post, 3, user: followed_user) }

  before do
    sign_in(signed_in_user)
  end

  it 'allows a user to like a post' do
    visit user_posts_path(signed_in_user)
    expect(page).to have_css("[data-turbo-frame='like_action_#{followed_user_posts[0].id}']")
    expect(page).to have_css("#post-#{followed_user_posts[0].id}-like-count", text: /0 likes/)
    find("[data-turbo-frame='like_action_#{followed_user_posts[0].id}'] button").click
    sleep 0.3
    expect(page).to have_css("#post-#{followed_user_posts[0].id}-like-count", text: /1 like/)
  end
  
  it 'does not allow a user to like a post more than once' do
    visit user_posts_path(signed_in_user)
    find("[data-turbo-frame='like_action_#{followed_user_posts[0].id}'] button").click
    expect(page).to have_css("#post-#{followed_user_posts[0].id}-like-count", text: /1 like/)
    find("[data-turbo-frame='like_action_#{followed_user_posts[0].id}'] button").click
    expect(page).to have_content("You've already liked this post")
  end

  it 'does not allow a user to like their own post' do
    visit user_posts_path(signed_in_user)
    find("[data-turbo-frame='like_action_#{signed_in_user_posts[0].id}'] button").click
    expect(page).to have_content("You can't like your own post")
  end
  
  private
  def sign_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'
    expect(page).to have_current_path(root_path, wait: 5)
  end
end