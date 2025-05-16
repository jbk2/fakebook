require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Fakebook
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1


    ########################### FROM OLD CONFIG RAILS 7.2.0 ###########################
    puts "RAILS_MASTER_KEY: #{ENV['RAILS_MASTER_KEY']}"

     # Override secret_key_base
    # config.secret_key_base = Rails.application.credentials.secret_key_base

    # config.add_autoload_paths_to_load_path = false

    config.active_job.queue_adapter = :sidekiq

    # config.active_support.cache_format_version = 7.1

    ###################################################################################


    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
