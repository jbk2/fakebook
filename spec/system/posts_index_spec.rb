require 'rails_helper'

describe 'Posts Index', type: :system do
  before { driven_by(:selenium_chrome_headless) }
  let!(:user) { create(:user) }
  
  let!(:post) { create_list(:post_with_photos, 2, user: user) }
  
  
  before do
    sign_in user
    visit user_posts_path(user)
  end
  
  it 'has a form to create new posts' do
    expect(page).to have_css('#new_post_card')
  end
  
  it 'has a posts turbo_frame' do
    expect(page).to have_css('turbo-frame#posts')
  end
  
  it "displays a post with all of it's constituent sections" do
    expect(page).to have_css("#post-#{post[0].id}-card")
    expect(page).to have_css(".post-card", count: 2)
    expect(page).to have_css("#post-#{post[0].id}-card .header")
    expect(page).to have_css("#post-#{post[0].id}-card .body")
    expect(page).to have_css("#post-#{post[0].id}-card .images")
    expect(page).to have_css("#post-#{post[0].id}-card .actions")
  end
  
  it 'allows a user to add a post without a photo' do
    fill_in 'post[body]', with: 'Test post with 1 photo'
    click_button 'Create Post'
    expect(page).to have_content('Post was successfully created')
  end

  it 'allows a user to add a post with one photo' do
    fill_in 'post[body]', with: 'Test post with 1 photo'
    find("#gallery-action").click
    attach_file('post[photos][]', Rails.root.join('spec', 'fixtures', 'jpg_test_img_1.jpg'), make_visible: true)
    click_button 'Create Post'
    expect(page).to have_content('Post was successfully created')
    expect(page).to have_css("img[src*='jpg_test_img_1.jpg']")
  end
  
  it 'allows a user to add a two jpg and two png photos' do
    fill_in 'post[body]', with: 'Test post with 1 photo'
    find("#gallery-action").click
    attach_file('post[photos][]', [
      Rails.root.join('spec', 'fixtures', 'jpg_test_img_1.jpg'),
      Rails.root.join('spec', 'fixtures', 'jpg_test_img_2.jpg'),
      Rails.root.join('spec', 'fixtures', 'png_test_img_1.png'),
      Rails.root.join('spec', 'fixtures', 'png_test_img_2.png'),
      ],
      make_visible: true)
    click_button 'Create Post'
    expect(page).to have_content('Post was successfully created')
    expect(page).to have_css("img[src*='jpg_test_img_1.jpg']")
    expect(page).to have_css("img[src*='jpg_test_img_2.jpg']")
    expect(page).to have_css("img[src*='png_test_img_1.png']")
    expect(page).to have_css("img[src*='png_test_img_2.png']")
  end
  
  it "displays only the user's and their followed_user's posts" do
    expect(page).to have_css(".post-card", count: 2)

    # create another user, follow them, have then create posts, and check they're displayed
    additional_user = create(:user)
    create(:follow, follower: user, followed: additional_user)
    create_list(:post_with_photos, 3, user: additional_user)
    visit current_path

    expect(page).to have_css(".post-card", count: 5)
    # page.save_screenshot('screenshot3.png')
  end
  

  private
  def sign_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'
  end
end