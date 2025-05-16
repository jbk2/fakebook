require 'rails_helper'

describe 'Users Index', type: :system do
  before { driven_by(:selenium_chrome_headless) }
  let!(:users) { create_list(:user, 4) }
  let!(:signed_in_user) { users.shift }
  
  before do
    sign_in(signed_in_user)
    visit users_path
  end
  
  it 'displays all users within cards on the page' do
    users.each do |user|
      expect(page).to have_css("#user-#{user.id}-card")
    end
  end

  it "does not show current_user in users#index" do
    expect(page).not_to have_css("#user-#{signed_in_user.id}-card")
  end

  it "each user card contains its constituent sections and information" do
    expect(page).to have_css(".card-profile-photo")
    expect(page).to have_css(".card-body")
    expect(page).to have_css(".card-actions")
  end

  it "shows a follow button in the user's card if current_user isn't following the user" do
    users.each do |user|
      expect(page).to have_css("#follow_action_button_#{user.id}", text: "Follow")
    end
  end

  it "shows an un-follow button in the user's card if current_user is following the user" do
    create(:follow, follower: signed_in_user, followed: users[0])
    visit current_path
    expect(page).to have_css("#follow_action_button_#{users[0].id}", text: "Un-Follow")
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