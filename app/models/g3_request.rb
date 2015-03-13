class G3Request < MifiRequest
  def pkey
    @data[11]
  end

  def valid?
    return mac_valid? && sign_verified?
    rescue
      nil
  end

  private
  def mac
    data[9]
  end

  def digest
    data[10]
  end

  def mac_key
    "\xFF\b3DUfw\x88\x99\xAA\x03\x04\x05\x06\a\b" # TODO
  end

  def sign_verified?
    return false if (input.nil? || digest.nil?)
    digest_valid?(pkey, input, digest)
  end
end
