require_relative './mifi_request.rb'
class G3Request < MifiRequest
  def pkey
    (count == 0) ? @data[11] : user.pkey
  end

  def save_pkey_at_first_count!
    return if count > 0
    user.update!(:pkey => pkey)
  end

  def valid?
    super && sign_verified?
  rescue
      nil
  end

  def mcc
    @data[5][0..1]
  end

  def mnc
    @data[5][2]
  end

  def count
    @data[2].unpack("H*")[0].to_i(16)
  end

  private
  def mac
    data[9]
  end

  def digest
    data[10]
  end

  def mac_key
    user.mac_key
  end

  def sign_verified?
    return false if (input.nil? || digest.nil?)
    digest_valid?(pkey, input, digest)
  end
end
