# README

## The Odin Project – RoR Final Project – Facebook clone (_Fakebook_)

---

### Summary
A facebook clone app which will featuring
- Complex forms; nesting, custom actions, hotwire.
- Advanced modeling & associations; m2m, polymorphic, delegation, custom validation, callbacks.
- Custom Devise authentication - on passengers, with conditional requirements ending user type.
- POROs - custom CSV parsing, data cleaning and merging and db seeding.
- SPA like - Turbo Frames, Streams & Stimulus serving dynamic flight search form and results
- Styling - TailwindCSS use & customisation of.

Technologies/libraries used:
  Frontend
  - TailwindCSS, DaisyUI, FontAwesome
  - Hotwire - Turbo; streams & frames, Stimulus JS (new_post_photo_controller)
  Backend
  - ActiveStorage
  - ActiveJob, ImageProcessing gem - handle queued job race conditions for attachment purging

#### Tech to implement
- Turbo Streams ✅
- Turbo Frames ✅
- Stimulus ✅
- Tailwindcss / DaisyUI ✅, FontAwesome ✅, 
- Devise ✅
- Omniauth
- Seeding, Faker gem ✅
- Complex forms; fields_for ✅
- Polmorphic models
- Custom validation, callbacks ✅
- POROs
- Active Storage ✅
- Active Job ✅
- Action Mailer
- Rspec; factories, Capybara ✅


### Full Test Coverage (Rspec, Shoulda-matchers, FactoryBot, Capybara, Selenium)

Unit Tests
  - Models; all tested for:
    - associations
    - validations
    - custom methods
  - ActiveJob; ProcessImageJob
    - unit tests

Request Tests
  - Authentication tested on all routes

Integration Tests
  - User.profile_photo integration with ProcessImageJob
  - Post.photos integration with ProcessImageJob

System Tests
  - Users index page
  - Posts index page
  - Following & Un-Following from Users index
  - Unfollowing from Posts index
  - Post Liking from Posts index 

---

### Next ToDos:
--------------------------------
_Conversation & Message Feature_
  
  Entity Relationship Modeling:
    - User has_many conversations
    - Conversation has_many messages
    - Message belongs_to conversation
    - Message belongs_to user

  Features:
    - messages button in navbar - which shows index of conversations in dropdown
      - click on a conversation and message card is displayed populated with that conversation
    
    - message button in user show view which reveals the message card, which only populates with messages from between the current_user and the user being viewed
      - display data more clearly in message card, i.e. who message form directed at, who
    
    - paginate conversations index and messages index
    
    - introduce notifications to indicate in UI when messages (unread) are waiting
--------------------------------

- Optimise for N+1 in views other than post#index
- Write factories & seed data for conversations and messages
- Build in omniauth Githuib Signin
- Set up a mailer to welcome new users (ActiveJob)
- RSPEC test, test, test - set in background with Guard
- Deploy App

### Future ToDos:

- General
  - Test everywhere everything
  - Allow User profile_photo to be null and if null render daisy placeholder avatar
  - ProcessImageJob - implement job chaining or tracking to ensure all jobs are completed before
    deletion
  - Integrate more partials, use strict locals where you can.

- Validations
  
- Features
  - Posts
    - Photos
      - allow additional photo add events to posts (?)
  - Comments
    - Add ability to like comments
    - Add ability to comment on/reply to comments
    - Add ability to add photos to comments
    - Add ability to Like comments (enable existing Likes model to be used for Comment and Post likes)

- UI
  - Posts
    - limit visible length of post.body's enabling reveal all in whole post in a modal
    - allow new post attachment files to preview pdfs as well as images
    - limit new post file attachment UI (& backend) to 6 files
  - Users
    - Index; populate data in users cards.
