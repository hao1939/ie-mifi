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
    user.mac_key
  end

  def sign_verified?
    return false if (input.nil? || digest.nil?)
    digest_valid?(pkey, input, digest)
  end
end
