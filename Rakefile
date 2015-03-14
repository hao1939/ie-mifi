# Rakefile
require "sinatra/activerecord/rake"
namespace :db do
  task :load_config do
    require File.expand_path('../myapp.rb',  __FILE__)
  end
end

require 'rake/testtask'
Rake::TestTask.new(:test => 'db:setup') do |t|
  t.pattern = "spec/**/*_spec.rb"
end

Dir.glob(File.expand_path('../lib/tasks/*.rake', __FILE__)).each { |r| load r}
