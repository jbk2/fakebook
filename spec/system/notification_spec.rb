require 'rails_helper'

describe 'Following', type: :system do
  before { driven_by(:selenium_chrome_headless) }
  
  let(:users) { create_list(:user, 3) }
  let(:user_1) { users[0] }
  let(:user_2) { users[1] }
  let(:user_3) { users[1] }
  # let(:conversation_u1_u2) { create(:conversation, participant_one: user_1, participant_two: user_2) }
  # let(:conversation_u1_u2_m1) { create(:message, body: 'message from u1 > u2', conversation: conversation_u1_u2, user: user_1) }
  # let(:conversation_u1_u2_m2) { create(:message, body: 'message from u2 > u1', conversation: conversation_u1_u2, user: user_2) }
  # let(:conversation_u1_u3) { create(:conversation, participant_one: user_1, participant_two: user_3) }
  # let(:conversation_u1_u3_m1) { create(:message, body: 'message from u1 > u3', conversation: conversation_u1_u3, user: user_1) }
  # let(:conversation_u1_u3_m2) { create(:message, body: 'message from u3 > u1', conversation: conversation_u1_u3, user: user_3) }
  # let(:conversation_u2_u3) { create(:conversation, participant_one: user_2, participant_two: user_3) }
  # let(:conversation_u2_u3_m1) { create(:message, body: 'message from u2 > u3', conversation: conversation_u2_u3, user: user_2) }
  # let(:conversation_u2_u3_m2) { create(:message, body: 'message from u3 > u2', conversation: conversation_u2_u3, user: user_3) }

  before do
    # sign_in(user_1)
    # sign_in(user_2)
    # sign_in(user_3)
  end

  before(:each) do
    ActionController::Base.allow_forgery_protection = true
  end

  after(:each) do
    ActionController::Base.allow_forgery_protection = false
  end

  # 1) U1 send message to u2, u2 does not have either conversations or conversation open - u1 does not get a notification and u2 gets a notification
  # 2) U1 send message to u2, u2 has conversations but not the conversation open - u1 does not get a notification and u2 does not get a notification
  # 3) U1 send message to u2, u2 does not have conversations open but does have the conversation open - u1 does not get a notification and u2 does not get a notification
  # 4) U1 send message to u2, u2 does not have conversations open but does have a different conversation open - u1 does not get a notification and u2 does get a notification

  # 1) U1 send message to u2, u2 does not have either conversations or conversation open - u1 does not get a notification and u2 gets a notification
  context 'when recipient has neither conversations nor the conversation open' do
    it 'a newly received message shows a notification ring around conversations' do
      sign_in(user_1)
      visit user_path(user_2)
      click_button 'Message'
      expect(page).to have_selector('#message-input', visible: true)
      expect(page).to have_field('message[body]', disabled: false)
      page.execute_script("document.getElementById('message-input').value = 'message from u1 to u2';")
      # fill_in 'message_input', with: 'message from u1 to u2' # this does not work - reason unknown
      find('button i.fa-paper-plane').click
      expect(page).not_to have_css('#conversations-dropdown.ring')
      
      using_session :user_2 do
        sign_in(user_2)
        visit root_path
        user_2.reload
        expect(user_2.active_conversation_id).to be_nil
        expect(page).to have_css('#conversations-dropdown.ring')

        find('#conversations-dropdown summary').click
        expect(page).to have_selector('#conversations-dropdown', text: 'message from u1 to u2')

        within('#conversations-dropdown') { find('a', text: 'message from u1 to u2').click }
        expect(page).to have_selector('#conversation-card', visible: true, text: 'message from u1 to u2')
      end
    end
  end

  context 'when the recipient has their conversations dropdown open' do
    let!(:conversation_u1_u2) { create(:conversation, participant_one: user_1, participant_two: user_2) }
    let!(:conversation_u1_u2_m1) { create(:message, body: 'u1 > u2', conversation: conversation_u1_u2, user: user_1) }
    let!(:conversation_u1_u2_m2) { create(:message, body: 'u2 > u1', conversation: conversation_u1_u2, user: user_2) }
  
    it 'the recipient will not receive a notification' do
      using_session :user_2 do
        sign_in(user_2)
        visit root_path
        find('#conversations-dropdown summary').click
        expect(page).to have_selector('#conversations-dropdown', text: 'u2 > u1')
      end

      using_session :user_1 do
        sign_in(user_1)
        visit user_path(user_2)
        click_button 'Message'
        expect(page).to have_selector('#message-input', visible: true)
        page.execute_script("document.getElementById('message-input').value = 'message from u1 to u2';")
        find('button i.fa-paper-plane').click
        sign_out(user_1)
      end

      using_session :user_2 do
        expect(page).to have_selector('#conversations-dropdown[open]')
        expect(page).not_to have_css('#conversations-dropdown.ring')
      end
    end
  end
  
  # context "when the recipient has the message's conversation dropdown open" do
  #   let!(:conversation_u1_u2) { create(:conversation, participant_one: user_1, participant_two: user_2) }
  #   let!(:conversation_u1_u2_m1) { create(:message, body: 'u1 > u2', conversation: conversation_u1_u2, user: user_1) }
  #   let!(:conversation_u1_u2_m2) { create(:message, body: 'u2 > u1', conversation: conversation_u1_u2, user: user_2) }

  #   let(:user1_session) { Capybara::Session.new(:selenium_chrome, Fakebook::Application) }
  #   let(:user2_session) { Capybara::Session.new(:selenium_chrome, Fakebook::Application) }
  
  #   it 'the recipient will not receive a notification' do
  #     user2_session.sign_in(user_2)
  #     user2_session.visit root_path
  #     user2_session.find('#conversations-dropdown summary').click
  #     expect(user2_session).to have_selector('#conversations-dropdown', text: 'u2 > u1')
  #     user2_session.within('#conversations-dropdown') do
  #       find('a', text: 'u2 > u1').click
  #     end
  #     expect(user2_session).to have_selector('#conversation-card', visible: true, text: 'u2 > u1')

    
  #     user1_session.sign_in(user_1)
  #     user1_session.visit root_path
      
  #     expect(user1_session).to have_button('Message')
  #     user1_session.click_button 'Message'
      
  #     expect(user1_session).to have_selector('#message-input', visible: true)
  #     user1_session.page.execute_script("document.getElementById('message-input').value = 'another from u1 to u2';")
  #     user1_session.find('button i.fa-paper-plane').click
  #     user1_session.sign_out(user_1)

  #     expect(user2_session).to have_selector('#conversation-card', visible: true, text: 'another from u1 to u2')
  #     expect(user2_session).not_to have_css('#conversations-dropdown.ring')
  #   end
  end