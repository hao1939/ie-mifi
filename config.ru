require File.expand_path('../myapp.rb',  __FILE__)
require File.expand_path('../config/initializers/sidekiq', __FILE__)
require 'sidekiq/web'

run Rack::URLMap.new(
  '/'       => MyApp,
  '/sidekiq' => Sidekiq::Web
)
