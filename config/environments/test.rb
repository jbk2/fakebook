require "active_support/core_ext/integer/time"

# The test environment is used exclusively to run your application's
# test suite. You never need to work with it otherwise. Remember that
# your test database is "scratch space" for the test suite and is wiped
# and recreated between test runs. Don't rely on the data there!

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # While tests run files are not watched, reloading is not necessary.
  config.enable_reloading = false

  # Eager loading loads your entire application. When running a single test locally,
  # this is usually not necessary, and can slow down your test suite. However, it's
  # recommended that you enable it in continuous integration systems to ensure eager
  # loading is working properly before deploying your code.
  config.eager_load = ENV["CI"].present?

  # Configure public file server for tests with Cache-Control for performance.
  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    "Cache-Control" => "public, max-age=#{1.hour.to_i}"
  }

  # Show full error reports and disable caching.
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false
  config.cache_store = :null_store

  if Rails.env.local?
    config.log_file_size = 100 * 1024 * 1024
  end

  # Render exception templates for rescuable exceptions and raise for other exceptions.
  config.action_dispatch.show_exceptions = :rescuable

  # Disable request forgery protection in test environment.
  config.action_controller.allow_forgery_protection = false

  # Store uploaded files on the local file system in a temporary directory.
  config.active_storage.service = :test

  config.action_mailer.perform_caching = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test

  # Configure Action View to use HTML5 standards-compliant sanitizers.
  config.action_view.sanitizer_vendor = Rails::HTML::Sanitizer.best_supported_vendor

  # Configure Action Text to use an HTML5 standards-compliant sanitizer.
  config.action_text.sanitizer_vendor = Rails::HTML::Sanitizer.best_supported_vendor

  # Enable the Active Job `BigDecimal` argument serializer, which guarantees
  # roundtripping. Without this serializer, some queue adapters may serialize
  # `BigDecimal` arguments as simple (non-roundtrippable) strings.
  config.active_job.use_big_decimal_serializer = true

  # To try to get tests to run Analyze jobs by forcing the queue adapter to be synchronous
  config.active_job.queue_adapter = :inline


  # See https://www.sqlite.org/quirks.html#double_quoted_string_literals_are_accepted for more details.
  config.active_record.sqlite3_adapter_strict_strings_by_default = true

  # Enable raising on assignment to attr_readonly attributes. The previous
  # behavior would allow assignment but silently not persist changes to the
  # database.
  config.active_record.raise_on_assign_to_attr_readonly = true

  # Enable a performance optimization that serializes Active Record models
  # in a faster and more compact way.
  config.active_record.marshalling_format_version = 7.1

  # Run `after_commit` and `after_*_commit` callbacks in the order they are defined in a model.
  config.active_record.run_after_transaction_callbacks_in_order_defined = true

  # Print deprecation notices to the stderr.
  config.active_support.deprecation = :stderr

  # Raise exceptions for disallowed deprecations.
  config.active_support.disallowed_deprecation = :raise

  # Tell Active Support which deprecation messages to disallow.
  config.active_support.disallowed_deprecation_warnings = []

  # For more information, see
  # https://guides.rubyonrails.org/v7.1/configuring.html#config-active-support-message-serializer
  config.active_support.message_serializer = :json_allow_marshal

  # Raises error for missing translations.
  # config.i18n.raise_on_missing_translations = true

  # Annotate rendered view with file names.
  # config.action_view.annotate_rendered_view_with_filenames = true

  # Raise error when a before_action's only/except options reference missing actions
  config.action_controller.raise_on_missing_callback_actions = true

  # Enable Bullet N+1 query identification from tests
  # config.after_initialize do
  #   Bullet.enable = true
  #   Bullet.bullet_logger = true
  #   # Bullet.raise = true
  # end
end
