# Rakefile
require "sinatra/activerecord/rake"
namespace :db do
  task :load_config do
    require 'active_record'
  end
end

require 'rake/testtask'
Rake::TestTask.new do |t|
  t.pattern = "spec/**/*_spec.rb"
end

Dir.glob(File.expand_path('../lib/tasks/*.rake', __FILE__)).each { |r| load r}
