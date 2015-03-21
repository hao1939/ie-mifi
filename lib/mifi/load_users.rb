def load_users_from_file(filename)
  User.connection
  puts "User before import: #{User.count}"
  file = File.open(filename)
  file.each do |line|
    next if line.start_with?('//', '#') || line.blank?
    attrs = line.split(",")

    id = attrs[0].to_i(16)
    user = User.find_or_initialize_by(:id => id)
    user.mac_key = attrs[1].hex_to_bytes
    user.reserved_key = attrs[2].hex_to_bytes
    user.rfm_encrypt_key = attrs[3].hex_to_bytes
    user.rfm_mac_key = attrs[4].hex_to_bytes
    user.rfm_count = attrs[5].hex_to_bytes

    puts user.inspect
    user.save!
  end
  puts "User after import: #{User.count}"
end
