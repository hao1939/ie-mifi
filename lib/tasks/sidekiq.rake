namespace :sidekiq do
  desc "start sidekiq to process background jobs"
  task :start do
    sidekiq_config = 'config/sidekiq.yml'
    exec "sidekiq -d -C #{sidekiq_config} -r ./app/workers/workers.rb"
  end

  task :stop do
    # TODO clean_pid YAML.load_file('config/sidekiq.yml')['pidfile']
  end
end
