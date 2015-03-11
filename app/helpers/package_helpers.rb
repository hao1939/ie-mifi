module MyAppHelpers

  def parse_body(io)
    data = []
    version = io.read(1)
    data << version
    begin
      byte = io.read(1)
      break if byte.nil?
      size = byte.unpack('H*')[0].hex
      data << io.read(size)
    end while(true)
    io.rewind
    raw = io.read
    return data, raw
  end

end
