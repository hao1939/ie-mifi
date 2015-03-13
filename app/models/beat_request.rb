class BeatRequest < MifiRequest
  private
  def mac
    data[3]
  end

  def mac_key
    "\x11\"3DUfw\x88\x99\xAA\xBB\xCC\xDD\xEE\xFF\x00".b # TODO
  end
end
