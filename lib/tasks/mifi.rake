require 'sinatra/activerecord'
require File.expand_path('../../../app/models/user.rb', __FILE__)

namespace :mifi do
  desc "import users from ENV['file'] to database"
  task :import do
    User.connection
    puts "User before import: #{User.count}"
    file = File.open(ENV['file'])
    file.each do |line|
      next if line.start_with?('//', '#') || line.blank?
      attrs = line.split(",")

      id = attrs[0].to_i(16)
      user = User.find_or_initialize_by(:id => id)
      user.mac_key = attrs[1].scan(/../).map { |x| x.hex.chr }.join
      user.reserved_key = attrs[2].scan(/../).map { |x| x.hex.chr }.join
      user.rfm_encrypt_key = attrs[3].scan(/../).map { |x| x.hex.chr }.join
      user.rfm_mac_key = attrs[4].scan(/../).map { |x| x.hex.chr }.join
      user.rfm_count = attrs[5].scan(/../).map { |x| x.hex.chr }.join

      puts user.inspect
      user.save!
    end
    puts "User after import: #{User.count}"
  end
end
