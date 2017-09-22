Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://127.0.0.1:6379/12' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://127.0.0.1:6379/12' }
end

schedule_file = File.join(Rails.root, "config/scheduler/#{Rails.env}.yml")
if Sidekiq.server? && File.exists?(schedule_file)
  Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
end