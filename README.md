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
  - 
  Backend
  - 

#### Tech to implement
- Turbo Streams
- Turbo Frames
- Stimulus ✅
- Tailwindcss / DaisyUI ✅, FontAwesome ✅, 
- Devise ✅
- Omniauth
- Seeding, Faker gem
- Complex forms; fields_for
- Polmorphic models
- Custom validation, callbacks
- POROs
- Active Storage
- Active Job
- Action Mailer
- Rspec


### Rspec Tested
  - 

---

### Next ToDos:

- Use ImageProcessingJob to process user.profile_photos as well as post.photos
- Integrate pagination, then with JS scroll loading
- Stop posts index loading all posts on page load, paginate (maybe) and load on scroll by turbo
- Reduce profile image sizes, and render different preloaded ones for different uses
- Create User profile page - contains profile info and all of their posts
- Create Users#index page
- Enable comments on posts
- Enable likes on posts
- Limit posts#index to only authored & friends posts
- Enable chat
- Use Turbo to lazy load posts.

### Future ToDos:

- General
  - Test everywhere everything
  - Allow User profile_photo to be null and if null render daisy placeholder avatar
  - 

- Validations
  
- Features
  - Posts
    - Photos
      - allow additional photo add events to posts (?)

- UI
  - Posts
    - limit visible length of post.body's enabling reveal all in whole post in a modal
    - allow new post attachment files to preview pdfs as well as images
