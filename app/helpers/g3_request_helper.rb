module G3RequestHelpers
  def bind_card
    @user.unbind
    @user.bind(@sim_card)
  end
end
