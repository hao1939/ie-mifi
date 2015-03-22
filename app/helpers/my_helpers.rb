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

  def bind_card(user, card)
    user.unbind
    user.bind(card)
  end

  class NoMoreSimCard < RuntimeError
  end

  def select_an_avaliable_card
    # TODO
    sim_card = SimCard.free_cards.first
    sim_card.mark
    sim_card
  rescue
    raise NoMoreSimCard, 'no more sim_card!'
  end
end
