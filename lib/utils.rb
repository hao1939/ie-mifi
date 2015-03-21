module MyStringUtils
  def hex_to_bytes
    self.scan(/../).map { |x| x.hex.chr }.join
  end
end

class String
  include MyStringUtils
end
