def load_sim_card_init(filename)
  SimCardInit.connection
  puts "SimCardInit before import: #{SimCardInit.count}"
  file = File.open(filename, 'r:utf-8')
  file.each do |line|
    next if line.start_with?('//', '#') || line.blank?
    attrs = line.split(",")

    sim_card_init = SimCardInit.new
    sim_card_init.mcc = attrs[0].hex_to_bytes
    sim_card_init.mnc = attrs[1].hex_to_bytes
    sim_card_init.country = attrs[2]
    sim_card_init.network = attrs[3]
    sim_card_init.file_2ff1 = sprintf("2ff1%02x%s", attrs[4].length / 2 , attrs[4]).hex_to_bytes
    sim_card_init.init_file_2ff1 = sprintf("2ff1%02x%s", attrs[5].length / 2 , attrs[5]).hex_to_bytes
    sim_card_init.memo = attrs[6]

    puts sim_card_init.inspect
    sim_card_init.save!
  end
  puts "SimCardInit after import: #{SimCardInit.count}"
end
