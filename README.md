# The Odin Project – RoR Final Project – Facebook clone (_Fakebook_)

## App Description

*A facebook clone app, built by James Kemp, to demonstrate use of the following libraries, technologies &
techniques:*

### Ruby, & Rails
- 🖇️ Complex forms; nesting, custom actions, hotwire.
- 👫 Advanced associations; many to many, custom validation, callbacks, delegation, _polymorphic_.
- 🔐 Authentication with Devise; controller extension.
- ⚙️ Helpers & POROs:
  - Hand built image processing; size, format, purge, via ActiveStorage (direct serve) & Vips.
  - Helpers; time formatting in views, devise controller & action helpers, conversation service.
- 🔔 Hand built message UI Notification service.
- ⏳ ActiveJob; 
  - ProcessImageJob; size and format processing of uploaded images.
  - BroadcastMessageJob; builds message & conversation partials then ActionCable broadcasts.
  - MessageNotificationJob; manages UI notifications for unread messages.
- 🗄️ ActiveStorage; attachments, variants, metadata, direct serve. Great [article](https://discuss.rubyonrails.org/t/active-storage-in-production-lessons-learned-and-in-depth-look-at-how-it-works/83289).
- 📡 ActionCable; managing conversation scoped subcriptions and broadcast DOM updates.
- 📧 ActionMailer; user_mailer sends welcome_email on user sign ups.

### Hotwire
#### 🔁 Turbo
  - 🖼️ Frames & streams; used in User, Post, Comment, Conversation & Message views.
  - 🔄 Turbo 8; using view transitions & turbo morphing.

#### 👮🏼 Stimulus 
  - To manage post image attachments & previewing.
  - To subscribe to correct ActionCable channels.
  - To toggle UI elements and add to clipboard.
  - To manage scroll position of conversation containers.
  - To manage message notifications.

### Testing
  - Using Rspec, shoulda matchers, factory-bot, fixtures, selenium.
  - All models, jobs, channels and mailers unit and where relevant integration tested.
  - Request and authentication tested on all routes.
  - System tests for all key features and user actions tested.

### 🎨 Styling
  - Most styling done with TailwindCSS & DaisyUI component library.

### 💻 Devops:
  - containerised microservice architecture on an AWS EC2 Ubuntu instance.
  - docker built & composed 5 services (ECR & docker-hub); web, sidekiq, nginx, postgres, redis.
  - Uses Nginx web, SSL only.
  - Bash scripting & systemd automates DNS records and server updates.

---

## App Usage Instructions

### Use live app at https://fakebook.bibble.com
- Log in to an pre-populated user account:
  - email; 1@test.com (accounts for _1-10_@test.com exist)
  - password; 'Password12!'
- Signup to your own account [here](http://fakebook.bibble/users/sign_up),
  you'll need to create posts, comments and follow others to populate your accounts.

### Run locally
1. Clone from [here](https://github.com/jbk2/fakebook.git) into a local repo
2. Run `bundle` on cmdline
3. Run db:create
4. Run db:migrate
5. Run db:seed
6. Run rails server via Foreman procfile with `bin/dev`

---

## DevOps Setup Notes

### Docker
- dev.Dockerfile & prod.Dockerfile written for their respective environments.
- Must manually compile assets locally (by cssbundling-rails gem (uses Node)) before production image
  build; `bin/rails assets:clobber`, `bin/rails assets:precompile`, ∴ no Node rqd on server.
- To build development or production images adjust docker-compose.yml web and
  sidekiq services to build from appropriate prod. or dev. dockerfile. (Should adjust to be able
  to pass in environment argument.)
- redis_url adjustments for running on 1) localhost or 2) separate service:
  - config/cable.yml; 1) 'redis://localhost:6379/1' 2) 'redis://redis:6379/1'
  - config/initializers/sidekiq.rb; 1) 'redis://localhost:6379/0' 2) 'redis://redis:6379/0'
  - set default_url_options in production.rb
  <!-- - comment out `require('daisyui')` from tailwind.config.js (current build ok with this daisyui require) -->
  <!-- - comment out application.html.erb daisyui CDN link for loval development. -->
- must define RAILS_MASER_KEY with `docker compose up` command on the server, i.e.:
  `RAILS_MASTER_KEY=my_prod_key_value docker compose up`.

### AWS S3
- Uses `'fakebook-s3-<%= Rails.env %>' buckets for both development and production, under user 'fakebook',
  with the 'fakebook-s3-policy' permissions applied. AWS access key values stored in credentials.

### AWS ECR
- See SERVER_INFO.md for ECR image URIs.

### Maintenance
- ssh into EC2 instance with - `ssh fakebook-ec2:ubuntu`, set via the local ~/.ssh/config file.
- Cronjobs, via Whenever gem, are used to run cleanup tasks.
  - On deployment need to run `bundle exec whenever --update-crontab` (see /config/schedule.rb)

---

## Server Scripting Documentation

This repo contains scripts to create an auto DNS update systemd service. Executing ./setup.sh locally will:
  - scp's the local ./.env, ./settings.sh & /dns-update.sh file to the remote server.
  - creates a systemd unit file, enables then starts service, so to run the update-dns.sh script on each server restart.

### Variable Configuration
The following variables configure the setup and deploy steps, edit with correct values:

In `.env`:
| Variable | Description                              |
|----------|------------------------------------------|
| `SERVER` | Virtual machine public IP (default hardcoded) |
| `SERVER_NAME` | Domain name (with correct DNS settings) (default hardcoded) |
| `USER` | Name for the user that will replace *ubuntu* for administration (default 'deploy' is hardcoded) |
| `SSH_KEY` | Path to the private SSH key (default hardcoded) |
|----------|------------------------------------------|
| `CF_API_TOKEN` | CloudFlare API token with the assigned domain's DNS editing permissions |
| `ZONE_ID` | The zone id of the assigned domain name |
| `RECORD_ID` | The DNS record ID number that needs updating on restart |
| `RECORD_NAME` | The DNS record name number that needs updating on restart |

### DNS Record Setup _(via cloudflare)_
- To point a domain name to the EC2 instance you must:
  1. Manually create 2 DNS 'A records' pointing to the EC2 instance's public IP address:
    - one named; 'www'
    - one named; 'domain_name.tld'
  2. Update the DNS variable values in ./.env with:
    - cloudflare api token for domain (via https://dash.cloudflare.com/profile/api-tokens)
    - domain's cloudflare zone - get value from cloudflare api at below endpoint:
    `curl -X GET "https://api.cloudflare.com/client/v4/zones" -H "Authorization: Bearer YOUR_API_TOKEN" -H "Content-Type: application/json"`
    - the dns record(s) name and id - get value from cloudflare api at below endpoint:
    `curl -X GET "https://api.cloudflare.com/client/v4/zones/YOUR_ZONE_ID/dns_records" -H "Authorization: Bearer YOUR_API_TOKEN" -H "Content-Type: application/json"`
  3. Ensure that the setup.sh script unit named 'dns_auto_update' has run (after the settings.sh variables values are updated).
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

- Style for dark mode
- update factories and model tests with user.active_conversation_id and message.read_by_recipient columns
- fix duplicate Notifications and Conversations Stimulus controller connections and disconnections
- utilise dom_id helper
- mailer functionality - notification emails if messages not read for period of time
- Optimise for N+1 in views other than post#index (partially done)
- Build in omniauth Githuib Signin (not done)
- Js testing on Channels
- Set RSpec up with Guard
- Deploy App
- Add action text
- Add elastic search

### Future ToDos:

- **General**
  - ProcessImageJob - implement job chaining or tracking to ensure completion and no race issues
  - Integrate more partials, use strict locals where you can.
  - Extend validations
  
- **Features**
  - Comments
    - Built ability to like comments (enable existing Likes model to be used for Comment and Post likes - i.e. make Polymorphic)
    - Build ability to comment on/reply to comments
    - Build ability to add photos to comments
  - Notifications
    - Extend notifications to include likes, comments, follows.

- **UI**
  - Posts
    - allow new post attachment files to preview pdfs as well as images
    - limit new post file attachment UI (& backend) to 6 files