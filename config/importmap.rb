# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin "tailwindcss", to: "https://cdn.jsdelivr.net/npm/tailwindcss@3.0.0/dist/tailwind.min.js"
pin "daisyui", to: "https://cdn.jsdelivr.net/npm/daisyui@latest/dist/full.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "@rails/actioncable", to: "actioncable.esm.js"
pin_all_from "app/javascript/channels", under: "channels"
