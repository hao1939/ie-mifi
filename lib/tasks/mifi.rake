require 'sinatra/activerecord'
require File.expand_path('../../../app/models/user.rb', __FILE__)
require File.expand_path('../../utils/load_users.rb', __FILE__)

namespace :mifi do
  desc "import users from ENV['file'] to database"
  task :import do
    load_users_from_file(ENV['file'])
  end
end
