require_relative './config/initializers/sidekiq.rb'
require_relative './config/initializers/mifi-card_reader.rb'
require_relative './myapp.rb'
require 'sidekiq/web'

run Rack::URLMap.new(
  '/'       => MyApp,
  '/sidekiq' => Sidekiq::Web
)
