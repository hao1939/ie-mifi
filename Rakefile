# Rakefile
require "sinatra/activerecord/rake"
namespace :db do
  task :load_config do
    require File.expand_path('../myapp.rb',  __FILE__)
  end
end

require 'rake/testtask'
Rake::TestTask.new do |t|
  t.pattern = "spec/**/*_spec.rb"
end
