module G3RequestHelpers
  def bind_card(user, card)
    user.unbind
    user.bind(card)
  end

  def select_an_avaliable_card
    # TODO
    SimCard.create
  end
end
