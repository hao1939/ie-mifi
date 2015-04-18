def load_roaming_sim(filename)
  SimCardInit.connection
  puts "SimCardInit before import: #{SimCardInit.count}"
  file = File.open(filename, 'r:utf-8')
  file.each do |line|
    next if line.start_with?('//', '#') || line.blank?
    attrs = line.split(",")

    mcc = attrs[0].hex_to_bytes
    mnc = attrs[1].hex_to_bytes

    sim_card_init = SimCardInit.find_or_initialize_by(:mcc => mcc.b, :mnc => mnc.b)
    sim_card_init.country = attrs[2]
    sim_card_init.network = attrs[3]
    # attrs[4]
    # attrs[5]
    sim_card_init.file_2ff1 = sprintf("2ff1%02x%s", attrs[6].length / 2 , attrs[6]).hex_to_bytes
    sim_card_init.init_file_2ff1 = sprintf("2ff1%02x%s", attrs[7].length / 2 , attrs[7]).hex_to_bytes
    sim_card_init.memo = attrs[8]

    puts sim_card_init.inspect
    sim_card_init.save!
  end
  puts "SimCardInit after import: #{SimCardInit.count}"
end
