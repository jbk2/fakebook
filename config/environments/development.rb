require "active_support/core_ext/integer/time"

Rails.application.configure do
  config.after_initialize do
    Bullet.enable        = true
    Bullet.alert         = true
    Bullet.bullet_logger = true
    Bullet.console       = true
    Bullet.rails_logger  = true
    Bullet.add_footer    = true
  end

  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded any time
  # it changes. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.enable_reloading = true

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable server timing
  config.server_timing = true

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  if Rails.root.join("tmp/caching-dev.txt").exist?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      "Cache-Control" => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  if Rails.env.local?
    config.log_file_size = 100 * 1024 * 1024
  end

  config.log_level = :debug

  # Store uploaded files on the local file system (see config/storage.yml for options).
  config.active_storage.service = :local

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_caching = false

  # Configure Action View to use HTML5 standards-compliant sanitizers.
  config.action_view.sanitizer_vendor = Rails::HTML::Sanitizer.best_supported_vendor

  # Configure Action Text to use an HTML5 standards-compliant sanitizer.
  config.action_text.sanitizer_vendor = Rails::HTML::Sanitizer.best_supported_vendor

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise exceptions for disallowed deprecations.
  config.active_support.disallowed_deprecation = :raise

  # Tell Active Support which deprecation messages to disallow.
  config.active_support.disallowed_deprecation_warnings = []

  # See https://www.sqlite.org/quirks.html#double_quoted_string_literals_are_accepted for more details.
  config.active_record.sqlite3_adapter_strict_strings_by_default = true

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true

  # Enable raising on assignment to attr_readonly attributes. The previous
  # behavior would allow assignment but silently not persist changes to the
  # database.
  config.active_record.raise_on_assign_to_attr_readonly = true

  # Enable a performance optimization that serializes Active Record models
  # in a faster and more compact way.
  config.active_record.marshalling_format_version = 7.1

  # Run `after_commit` and `after_*_commit` callbacks in the order they are defined in a model.
  config.active_record.run_after_transaction_callbacks_in_order_defined = true

  # Highlight code that enqueued background job in logs.
  config.active_job.verbose_enqueue_logs = true

  # Enable the Active Job `BigDecimal` argument serializer, which guarantees
  # roundtripping. Without this serializer, some queue adapters may serialize
  # `BigDecimal` arguments as simple (non-roundtrippable) strings.
  config.active_job.use_big_decimal_serializer = true

  # For more information, see
  # https://guides.rubyonrails.org/v7.1/configuring.html#config-active-support-message-serializer
  config.active_support.message_serializer = :json_allow_marshal

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations.
  # config.i18n.raise_on_missing_translations = true

  # Annotate rendered view with file names.
  # config.action_view.annotate_rendered_view_with_filenames = true

  # Uncomment if you wish to allow Action Cable access from any origin.
  # config.action_cable.disable_request_forgery_protection = true

  # Raise error when a before_action's only/except options reference missing actions
  config.action_controller.raise_on_missing_callback_actions = true
  config.action_controller.default_url_options = { host: 'localhost', port: 3000 }

  config.active_job.queue_adapter = :sidekiq

  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
  config.action_mailer.delivery_method = :letter_opener
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.preview_path = "#{Rails.root}/spec/mailers/previews"

  
  # Config for Bullet N+1 query identification gem
  config.after_initialize do
    Bullet.enable = true
    Bullet.alert = false # Pop up a JavaScript alert in the browser
    Bullet.bullet_logger = true # Log to the Bullet log file
    # Bullet.console = true # Log warnings to your browser's console.log
    Bullet.rails_logger = false # Add warnings directly to the Rails log
    # Bullet.add_footer = true # Add a footer with debug info to the HTML
  end

  # config.force_ssl = false
end
