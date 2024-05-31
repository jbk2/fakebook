Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://localhost:6379/0' }
  # config.redis = { url: 'redis://redis:6379/0' } # for Docker
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://localhost:6379/0' }
  # config.redis = { url: 'redis://redis:6379/0' } # for Docker
end