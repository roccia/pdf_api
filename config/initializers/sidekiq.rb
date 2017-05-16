Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://125.208.9.73:6379/12' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://125.208.9.73:6379/12' }
end