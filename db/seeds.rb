Dir.glob(File.expand_path('../../lib/mifi/*.rb', __FILE__)).each { |r| require r}

load_users_from_file(File.expand_path('../seeds/users.txt', __FILE__))
load_sim_card_init(File.expand_path('../seeds/roaming_sim.txt', __FILE__))

data = '6F0709' + '084906107035976095' + '6F600664F0108000FF' + '6F7B0564F000FFFF'
data_files = data.hex_to_bytes
imsi = data_files[3..11]
file_2ff1 = "2FF1090103010203040201".hex_to_bytes
# TODO test only, we should remove it
SimCard.create!(:imsi => imsi,
  :mcc => "\x64\xf0",
  :mnc => "\x10",
  :data_files => data_files,
  :status => 'free')
SimCard.create!(:network_enabled => true,
  :imsi => imsi,
  :mcc => "\x64\xf0",
  :mnc => "\x10",
  :data_files => data_files,
  :status => 'free')
puts "SimCard after seed: #{SimCard.count}"
