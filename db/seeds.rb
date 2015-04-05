Dir.glob(File.expand_path('../../lib/mifi/*.rb', __FILE__)).each { |r| require r}

load_users_from_file(File.expand_path('../seeds/users.txt', __FILE__))
load_roaming_sim(File.expand_path('../seeds/roaming_sim.txt', __FILE__))
