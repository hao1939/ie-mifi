require File.expand_path('../../lib/utils/load_users.rb', __FILE__)

load_users_from_file(File.expand_path('../users.txt', __FILE__))

# TODO create a sim_card
data = "6F07090849061070359760956F600664F0108000FF6F7B0564F000FFFF2FF1090103010203040201"
data_files = data.scan(/../).map { |x| x.hex }.pack('c*')
imsi = data_files[3..11]
SimCard.create!(:imsi=> imsi, :data_files => data_files, :status => 'free')
