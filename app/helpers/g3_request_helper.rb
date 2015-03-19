module G3RequestHelpers
  def bind_card(user, card)
    user.unbind
    user.bind(card)
  end

  def select_an_avaliable_card
    # TODO
    sim_card = SimCard.free_cards.first
    sim_card.mark
    sim_card
  end
end
