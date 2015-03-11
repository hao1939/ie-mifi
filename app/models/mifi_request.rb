class MifiRequest
  include MifiCrypt

  def initialize(data, raw)
    @data = data
    @raw = raw
    @mac = data[9]
    @digest = data[10]
  end

  attr_accessor :data

  def valid?
    return mac_valid? && sign_verified?
    rescue
      nil
  end

  def pkey
    @data[11]
  end

  private
  def input
    # raw = "1+input+08+mac+..."
    @input ||= @raw[1..(@raw.index(@mac) -2)]
  end

  def mac_valid?
    return false if (input.nil? || @mac.nil?)
    mac_key = "\xFF\b3DUfw\x88\x99\xAA\x03\x04\x05\x06\a\b" # TODO
    @mac == des3mac(input, mac_key)
  end

  def sign_verified?
    return false if (input.nil? || @digest.nil?)
    digest_valid?(pkey, input, @digest)
  end
end
