class MifiRequest
  include MifiCrypt

  def initialize(data, raw)
    @data = data
    @raw = raw
  end

  attr_accessor :data

  def user
    @user ||= User.find(@data[1].unpack('N*')[0])
  end

  def card_binding
    @card_binding ||= user.card_bindings.last
  end

  def valid?
    return !user.nil? && mac_valid?
  rescue
    nil
  end

  def input
    # raw = "1+input+08+mac+..."
    @input ||= @raw[1..(@raw.index(mac) -2)]
  end

  def mac
    data[3]
  end

  def mac_key
    card_binding.mac_key
  end

  def mac_valid?
    return false if (input.nil? || mac.nil?)
    mac == des3mac(input, mac_key)
  end

  def raw_to_hex
    @raw.unpack("H*")[0]
  end
end
