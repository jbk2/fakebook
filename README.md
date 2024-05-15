# README

## The Odin Project – RoR Final Project – Facebook clone (_Fakebook_)

---

### Summary
*A facebook clone app featuring:*

- 🖇️ Complex forms; nesting, custom actions, hotwire.
- 👫 Advanced associations; m2m, polymorphic, custom validation, callbacks, delegation. 
- 🔐 Authentication with Devise.
- ⚙️ Helpers & POROs:
  - Custom logic to process (size & format(Vips)) uploaded images to ActiveStorage.
  - helpers to display #format_time_from in posts, comments & messages.
- ⚡️ SPA like; Turbo Frames, Streams & Stimulus:
  🖼️ - Turbo frames & streams:
     used in various User, Post, Comment, Conversation & Message views.
  👮🏼 - Stimulus Controllers used:
    - for managing post image attachments and previewing.
    - for toggling comment form presence on posts.
    - for subscribing to ActionCable ConversationChannel when a conversation is opened.
    - for managing scroll of messages container in conversation-card.
- 📡 ActionCable; ConversationChannel manages conversation scoped subcriptions and message updates into the DOM.
- ⏳ ActiveJob; 
  - ProcessImageJob - size and format processing of uploaded images.
  - BroadcaseMessageJob - ActionCable broadcasts messages after creation.
- 🎞️ ActiveStorage; attachments, variants, metadata, [excellent article](https://discuss.rubyonrails.org/t/active-storage-in-production-lessons-learned-and-in-depth-look-at-how-it-works/83289).
- 📧 Mailer Functionality; Welcome email on user sign up.
- 🎨 Styling - All styling done with TailwindCSS & DaisyUI component library.

---

**Technologies/libraries used:**
  Frontend
  - TailwindCSS, DaisyUI, FontAwesome
  - Hotwire - Turbo; streams & frames, Stimulus JS (new_post_photo_controller)
  Backend
  - ActiveStorage
  - ActiveJob, ImageProcessing gem - handle queued job race conditions for attachment purging

---

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
- POROs ✅
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
---

- refactor conversations and messages controllers:
  - rationalise #find_or_create_user between controllers
  - have user#show message button uses Restful path, i.e. post to messages_path calling #create
  - build message create form with @conversation too, perhaps, so that the message is built on the conversation
  - use dom_id helper
- validate that there cannot be more than one conversation with the same 2 users
- introduce notifications to indicate in UI when messages (unread) are waiting
- mailer functionality - email on sign up, notification emails if messages not read for period of time
- Optimise for N+1 in views other than post#index (partially done)
- Write factories & seed data for conversations and messages (not yet done)
- Build in omniauth Githuib Signin (not done)
- RSPEC test, test, test - set in background with Guard
- Deploy App

### Future ToDos:

- **General**
  - Test everywhere everything
  - Allow User profile_photo to be null and if null render daisy placeholder avatar
  - ProcessImageJob - implement job chaining or tracking to ensure all jobs are completed before
    deletion
  - Integrate more partials, use strict locals where you can.
  - Extend validations
  
- **Features**
  - Posts
    - Photos
  - Comments
    - Add ability to like comments
    - Add ability to comment on/reply to comments
    - Add ability to add photos to comments
    - Add ability to Like comments (enable existing Likes model to be used for Comment and Post likes)

- **UI**
  - Posts
    - scroll post.body
    - allow new post attachment files to preview pdfs as well as images
    - limit new post file attachment UI (& backend) to 6 files
  - Users
    - Index; populate data in users cards.
