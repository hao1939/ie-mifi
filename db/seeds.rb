require File.expand_path('../../lib/utils/load_users.rb', __FILE__)

load_users_from_file(File.expand_path('../users.txt', __FILE__))
