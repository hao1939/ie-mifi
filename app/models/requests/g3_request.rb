require_relative './mifi_request.rb'
class G3Request < MifiRequest
  def pkey
    @data[11]
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
