class BeatRequest < MifiRequest
  def count
    @count ||= @data[2].unpack('N*')[0]
  end

  def client_shutdown?
    @data[4].to_i > 0 # "\x30".to_i = 0
  end
end
