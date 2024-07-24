# The Odin Project – RoR Final Project – Facebook clone (_Fakebook_)

## App description
*A facebook clone app featuring:*

- 🖇️ Complex forms; nesting, custom actions, hotwire.
- 👫 Advanced associations; many to many, custom validation, callbacks, delegation, _polymorphic_. 
- 🔐 Authentication with Devise.
- ⚙️ Helpers & POROs:
  - Custom logic to process uploaded images to ActiveStorage (size, format, purge) using vips.
  - helpers to display #format_time_from in posts, comments & messages.
- ⚡️ SPA like; Turbo Frames, Streams & Stimulus:
  - 🖼️ Turbo frames & streams:
    - used in various User, Post, Comment, Conversation & Message views.
  - 👮🏼 Stimulus Controllers used:
    - for managing post image attachments and previewing.
    - for toggling comment form presence on posts.
    - for subscribing to ActionCable ConversationChannel when a conversation is opened.
    - for managing scroll of messages container in conversation-card.
  - 🔁 Turbo 8; using view transitions & turbo morphing.
- 📡 ActionCable; ConversationChannel manages conversation scoped subcriptions and message updates into the DOM.
- ⏳ ActiveJob; 
  - ProcessImageJob; size and format processing of uploaded images.
  - BroadcastMessageJob; builds message & conversation partials and ActionCable broadcasts.
- 🗄️ ActiveStorage; attachments, variants, metadata, excellent [article](https://discuss.rubyonrails.org/t/active-storage-in-production-lessons-learned-and-in-depth-look-at-how-it-works/83289).
- 📧 Mailer Functionality; User_mailer sends welcome_email on user sign up.
- 🎨 Styling - Most styling done with TailwindCSS & DaisyUI component library.
- 💻 Devops:
  - containerised microservice architecture on an AWS EC2 Ubuntu instance.
  - docker built & composed 5 services via AWS ECR; web, sidekiq, nginx, postgres, redis.
  - Uses Nginx web server & only via SSL.
  - Bash scripting to automate cloudflare DNS records and server updates.

### Technologies/libraries used:
#### Frontend
- TailwindCSS, DaisyUI, FontAwesome
- Hotwire - Turbo; streams & frames, Stimulus JS (new_post_photo_controller)
#### Backend
- ActiveStorage, ActiveJob, ActionCable, ActionMailer + many more rails libraries.
- ImageProcessing gem - handle queued job race conditions for attachment purging

### Tech implemented
- Turbo Streams ✅
- Turbo Frames ✅
- Stimulus ✅
- Tailwindcss / DaisyUI ✅, FontAwesome ✅,
- Devise ✅
- Omniauth
- Seeding; Faker gem ✅
- Complex forms; fields_for ✅
- Polmorphic models
- Custom validation, callbacks ✅
- POROs ✅
- Active Storage ✅
- Active Job ✅
- Action Mailer ✅
- Rspec; factories, Capybara ✅
- Docker, AWS S3, ECR, EC2, scripting, systemd ✅

### Full Test Coverage (Rspec, Shoulda-matchers, FactoryBot, Capybara, Selenium)

Unit Tests
  - Models; unit tested:
    - associations & validations
    - custom logic
  - Unit & integration tests for:
    - ProcessImageJob & BroadcastMessageJob
    - ActionCable; ConversationChannel
    - ActionMailer; UserMailer

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

## Usage Instructions

### Use live app at https://fakebook.bibble.com

  - Log in to an pre-populated user account:
    - email; 1@test.com (accounts for _1-10_@test.com exist)
    - password; 'Password12!'
  - Signup to your own account [here](http://fakebook.bibble/users/sign_up),
  you'll need to create posts, comments and follow others to populate your accounts.

### Run locally

1. Clone into a local repo from [here](https:\\github...)
2. Run `bundle` on cmdline
3. Run db:create
4. Run db:migrate
5. Run db:seed
6. Run rails server via Foreman procfile with `bin/dev`

---

## DevOps Setup Notes

- Cronjobs, via Whenever gem, are used to run cleanup tasks.
  - On deployment need to run `bundle exec whenever --update-crontab` (see /config/schedule.rb)

### Docker
- dev.Dockerfile & prod.Dockerfile written for their respective environments.
- To build development or production images adjust docker-compose.yml web and
  sidekiq services to build from appropriate prod. or dev. dockerfile. (Should adjust to be able
  to pass in environment argument.)
- redis_url adjustments for running on 1) localhost or 2) separate service:
  - config/cable.yml; 1) 'redis://localhost:6379/1' 2) 'redis://redis:6379/1'
  - config/initializers/sidekiq.rb; 1) 'redis://localhost:6379/0' 2) 'redis://redis:6379/0'
  - set default_url_options in production.rb
  - comment out `require('daisyui')` from tailwind.config.js
  - comment out application.html.erb daisyui CDN link for loval development.
- must define RAILS_MASER_KEY with `docker compose up` command on the server, i.e.:
  `RAILS_MASTER_KEY=my_prod_key_value docker compose up`.

### AWS S3
- Uses `'fakebook-s3-<%= Rails.env %>' buckets for both development and production, under user 'fakebook',
  with the 'fakebook-s3-policy' permissions applied. AWS access key values stored in credentials.

### AWS ECR
- ssh into EC2 instance with - `ssh fakebook-ec2:ubuntu`, set via the local ~/.ssh/config file.

---

## Server Scripting Documentation

This repo contains scripts for auto set up of, and deployment to, a Linux Debian Ubuntu distribution,
to carry out the following:

- on running the ./setup.sh executable script file:
  - ssh's in as 'ubuntu' into the remote server.
  - scp's the local ./settings.sh & /dns-update.sh file to the remote server.
  - creates a systemd unit file to run the update-dns.sh script on each server restart.

### Variable Configuration
The following variables configure the setup and deploy steps, edit with correct values:

In `settings.sh`:
| Variable | Description                              |
|----------|------------------------------------------|
| `SERVER` | Virtual machine public IP (default hardcoded) |
| `SERVER_NAME` | Domain name (with correct DNS settings) (default hardcoded) |
| `USER` | Name for the user that will replace *ubuntu* for administration (default 'deploy' is hardcoded) |
| `SSH_KEY` | Path to the private SSH key (default hardcoded) |

In `dns_update.sh`:
| Variable | Description                              |
|----------|------------------------------------------|
| `CF_API_TOKEN` | CloudFlare API token with the assigned domain's DNS editing permissions |
| `ZONE_ID` | The zone id of the assigned domain name |
| `RECORD_ID` | The DNS record ID number that needs updating on restart |
| `RECORD_NAME` | The DNS record name number that needs updating on restart |

### DNS Record Setup _(via cloudflare)_
- To assign a domain name to the EC2 instance you must:
  1. Initially, manually create 2 DNS 'A records' pointing to the EC2 instance's public IP address:
    - one named; 'www'
    - one named; 'domain_name.tld'
  2. Update the DNS variable values in the ./settings.sh, with:
    - cloudflare api token for domain (via https://dash.cloudflare.com/profile/api-tokens)
    - domain's cloudflare zone - get value from cloudflare api at below endpoint:
    `curl -X GET "https://api.cloudflare.com/client/v4/zones" -H "Authorization: Bearer YOUR_API_TOKEN" -H "Content-Type: application/json"`
    - the dns record(s) name and id - get value from cloudflare api at below endpoint:
    `curl -X GET "https://api.cloudflare.com/client/v4/zones/YOUR_ZONE_ID/dns_records" -H "Authorization: Bearer YOUR_API_TOKEN" -H "Content-Type: application/json"`
  3. Ensure that the setup.sh script unit named 'dns_auto_update' has run, after the settings.sh variables values are updated.
  4. manually ssh into the server (update local ~/.ssh/config for easy ssh login with the EC2 instance's public ip, delete old 'known hosts') and run
    `systemctl status dns-update.service` to check that the systemd service has been created (it should be loaded and enabled, but inactive because it
    only runs on restart). If systemd service has been created successfully, then the DNS records will be now be automatically updated via cloudflare's
    API on each server restart.

### To run the scripts:
1. clone the repository
2. cd into the repository
3. update variable values in settings.sh
4. Setup; run `./setup.sh -h` in terminal to view ./setup.sh's help options:
  - run `./setup.sh` in terminal (without arguments runs all units & steps)

### Documentation
- SERVER_INFO.md file contains server instance info and is saved on the server instance at /etc/docs/SERVER_INFO.md

---

## ToDo List

### Next ToDos:

- refactor conversations and messages logic:
  - use dom_id helper
  - update conversations turbo_frame when any conversations have new messages, even when user isn't streaming from ConversationChannel.
- introduce notifications to indicate in UI when messages (unread) are waiting
- mailer functionality - notification emails if messages not read for period of time
- Optimise for N+1 in views other than post#index (partially done)
- Build in omniauth Githuib Signin (not done)
- Jest test ConversationChannel JS
- Set RSpec up with Guard
- Deploy App
- Add action text
- Add elastic search

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