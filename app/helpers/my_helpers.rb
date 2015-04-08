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

  def query_sim_cards(mcc, mnc)
    puts "Select card using mcc/mnc: {:mcc => #{mcc.inspect}, :mnc => #{mnc.inspect}}."
    return SimCard.with_mcc_mnc(mcc, mnc).first!
  rescue
    puts "Select card using mcc/mnc not found: {:mcc => #{mcc.inspect}, :mnc => #{mnc.inspect}}."
    SimCard.free_cards.first!
  end

  def select_an_avaliable_card(mcc = nil, mnc = nil)
    sim_card = query_sim_cards(mcc, mnc)
    sim_card.mark
    sim_card
  rescue => e
    raise NoMoreSimCard, 'no more sim_card!'
  end
end
