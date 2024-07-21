require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.enable_reloading = false

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both threaded web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true
  
  # config.action_controller.default_url_options = { host: Rails.application.credentials[:host], port: 3000 }
  config.action_controller.default_url_options = { host: 'fakebook.bibble.com', protocol: 'https' }

  # Ensures that a master key has been made available in ENV["RAILS_MASTER_KEY"], config/master.key, or an environment
  # key such as config/credentials/production.key. This key is used to decrypt credentials (and other encrypted files).
  # config.require_master_key = true

  # Disable serving static files from `public/`, relying on NGINX/Apache to do so instead.
  # config.public_file_server.enabled = false

  # Compress CSS using a preprocessor.
  # config.assets.css_compressor = :sass

  if Rails.env.local?
    config.log_file_size = 100 * 1024 * 1024
  end

  # Do not fall back to assets pipeline if a precompiled asset is missed.
  config.assets.compile = true

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.asset_host = "https://fakebook-s3-production.s3-eu-west-3.amazonaws.com"

  # Ensure the asset pipeline is enabled for production
  config.assets.compile = true
  config.assets.css_compressor = nil # Disable CSS compression if it interferes with Tailwind CSS

  # Add additional precompile assets
  config.assets.precompile += %w(tailwind.css)  

  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for Apache
  # config.action_dispatch.x_sendfile_header = "X-Accel-Redirect" # for NGINX

  # Store files on Amazon S3.
  config.active_storage.service = :amazon

  config.active_storage.resolve_model_to_route = :rails_storage_redirect

  # Mount Action Cable outside main process or domain.
  # config.action_cable.mount_path = nil
  config.action_cable.url = 'wss://fakebook.bibble.com/cable'
  config.action_cable.allowed_request_origins = [ 'https://fakebook.bibble.com', 'https://www.fakebook.bibble.com' ]

  # Assume all access to the app is happening through a SSL-terminating reverse proxy.
  # Can be used together with config.force_ssl for Strict-Transport-Security and secure cookies.
  # config.assume_ssl = true

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  config.force_ssl = true

  # Log to STDOUT by default
  config.logger = ActiveSupport::Logger.new(STDOUT)
    .tap  { |logger| logger.formatter = ::Logger::Formatter.new }
    .then { |logger| ActiveSupport::TaggedLogging.new(logger) }

  # Prepend all log lines with the following tags.
  config.log_tags = [ :request_id ]

  # "info" includes generic and useful information about system operation, but avoids logging too much
  # information to avoid inadvertent exposure of personally identifiable information (PII). If you
  # want to log everything, set the level to "debug".
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "debug")

  # Use a different cache store in production.
  # config.cache_store = :mem_cache_store

  # Use a real queuing backend for Active Job (and separate queues per environment).
  # config.active_job.queue_adapter = :resque
  # config.active_job.queue_name_prefix = "fakebook_production"

  
  # Configure Action View to use HTML5 standards-compliant sanitizers.
  config.action_view.sanitizer_vendor = Rails::HTML::Sanitizer.best_supported_vendor
  
  # Configure Action Text to use an HTML5 standards-compliant sanitizer.
  config.action_text.sanitizer_vendor = Rails::HTML::Sanitizer.best_supported_vendor
  
  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  config.action_mailer.raise_delivery_errors = true
  
  config.action_mailer.perform_caching = false
  config.action_mailer.perform_deliveries = true
  config.action_mailer.default_url_options = { host: Rails.application.credentials[:host], port: 3000 }
  config.action_mailer.default_url_options = { host: 'fakebook.bibble.com' }
  config.action_mailer.delivery_method = :postmark
  config.action_mailer.postmark_settings = { :api_token => "33c9c119-1446-4911-b53f-5e20233b5ad3" }
  # config.action_mailer.preview_path = "#{Rails.root}/spec/mailers/previews"  

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true

  # Enable the Active Job `BigDecimal` argument serializer, which guarantees
  # roundtripping. Without this serializer, some queue adapters may serialize
  # `BigDecimal` arguments as simple (non-roundtrippable) strings.
  config.active_job.use_big_decimal_serializer = true

  # Don't log any deprecations.
  config.active_support.report_deprecations = false

  # For more information, see
  # https://guides.rubyonrails.org/v7.1/configuring.html#config-active-support-message-serializer
  config.active_support.message_serializer = :json_allow_marshal

  # See https://www.sqlite.org/quirks.html#double_quoted_string_literals_are_accepted for more details.
  config.active_record.sqlite3_adapter_strict_strings_by_default = true

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  config.active_record.encryption.support_sha1_for_non_deterministic_encryption = false
  config.active_record.run_commit_callbacks_on_first_saved_instances_in_transaction = false

  # Enable raising on assignment to attr_readonly attributes. The previous
  # behavior would allow assignment but silently not persist changes to the
  # database.
  config.active_record.raise_on_assign_to_attr_readonly = true

  # Enable a performance optimization that serializes Active Record models
  # in a faster and more compact way.
  config.active_record.marshalling_format_version = 7.1

  # Run `after_commit` and `after_*_commit` callbacks in the order they are defined in a model.
  config.active_record.run_after_transaction_callbacks_in_order_defined = true

  # Enable DNS rebinding protection and other `Host` header attacks.
  # config.hosts = [
  #   "example.com",     # Allow requests from example.com
  #   /.*\.example\.com/ # Allow requests from subdomains like `www.example.com`
  # ]
  # Skip DNS rebinding protection for the default health check endpoint.
  # config.host_authorization = { exclude: ->(request) { request.path == "/up" } }
end

Rails.application.routes.default_url_options = { protocol: 'https', host: 'fakebook.bibble.com' }