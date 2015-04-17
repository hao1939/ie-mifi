require 'sidekiq'

Sidekiq.configure_server do |config|
  config.redis = {
    url: 'redis://localhost:6379/',
    pool_timeout: 10
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
    url: 'redis://localhost:6379/',
    pool_timeout: 10
  }
end

Sidekiq.default_worker_options = {:retry => false, 'backtrace' => true}
