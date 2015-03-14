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

  def valid?
    return !user.nil? && mac_valid?
  rescue
    nil
  end

  def to_s
    @s ||= "raw: #{@raw.unpack('H*')}"
  end

  private
  def input
    # raw = "1+input+08+mac+..."
    @input ||= @raw[1..(@raw.index(mac) -2)]
  end

  def mac_key
    raise new RuntimeError("'mac_key' should be overrided by subclass!")
  end

  def mac_valid?
    return false if (input.nil? || mac.nil?)
    mac == des3mac(input, mac_key)
  end
end
