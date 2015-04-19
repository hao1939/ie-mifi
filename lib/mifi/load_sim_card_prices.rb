require_relative '../../app/models/sim_card_price.rb'
def load_sim_card_prices(filename)
  SimCardPrice.connection
  puts "SimCardPrice before import: #{SimCardPrice.count}"
  file = File.open(filename, 'r:utf-8')
  file.each do |line|
    next if line.start_with?('//', '#') || line.blank?
    attrs = line.split(",").map {|x| x.strip}
    loc_mcc = attrs[0].hex_to_bytes
    card_mcc = attrs[2].hex_to_bytes
    card_mnc = attrs[3].hex_to_bytes
    sim_card_price = SimCardPrice.find_or_initialize_by(:loc_mcc => loc_mcc.b, :card_mcc => card_mcc.b, :card_mnc => card_mnc.b)
    sim_card_price.loc_country = attrs[1]
    sim_card_price.price = attrs[4]
    sim_card_price.local = (attrs[5] == '0')
    sim_card_price.memo = attrs[6]
    sim_card_price.save!
  end
  puts "SimCardPrice after import: #{SimCardPrice.count}"
end
