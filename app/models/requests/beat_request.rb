class BeatRequest < MifiRequest
  def count
    @count ||= @data[2].unpack('N*')[0]
  end
end
