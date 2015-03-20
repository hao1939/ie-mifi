require File.expand_path('../../lib/utils/load_users.rb', __FILE__)

load_users_from_file(File.expand_path('../users.txt', __FILE__))

# TODO create a sim_card
mcc_mnc = '084906107035976095'
data = '6F0709' + mcc_mnc + '6F600664F0108000FF' + '6F7B0564F000FFFF'
data_files = data.scan(/../).map { |x| x.hex }.pack('c*')
imsi = data_files[3..11]
file_2ff1 = "2FF1090103010203040201".scan(/../).map { |x| x.hex }.pack('c*')
SimCard.create!(:imsi => imsi, :mcc_mnc => mcc_mnc, :data_files => data_files, :file_2ff1 => file_2ff1, :status => 'free')
# TODO test only, we should remove it
SimCard.create!(:enabled => true, :imsi => imsi, :data_files => data_files, :file_2ff1 => file_2ff1, :status => 'free')
SimCardInit.create(:mcc_mnc => mcc_mnc, :file_2ff1 => '2FF102FFFF')
puts "SimCard after seed: #{SimCard.count}"
