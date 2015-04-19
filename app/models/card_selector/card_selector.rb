require_relative 'static_card_assignment.rb'
require_relative '../sim_card_price.rb'

class NoMoreSimCard < RuntimeError
end

class CardSelector
  def initialize(user, mcc, mnc)
    @user = user
    @mcc = mcc
    @mnc = mnc
  end

  def select_and_mark_card
    sim_card = select_card
    raise NoMoreSimCard, 'no more sim_card!' if !sim_card
    sim_card.mark!
    sim_card
  end

  private
  def select_card
    puts "Query static card assignment for user: #{@user.id}"
    static_card_assignment = StaticCardAssignment.active_assignment_for(@user.id).first
    if static_card_assignment
      sim_card = SimCard.find(static_card_assignment.sim_card_id)
      CardBinding.where(:sim_card => sim_card).each {|b| b.deactivate!}
      return sim_card if sim_card
    end
    puts "Query static card assignment for user not found: #{@user.id}"
    puts "Select card using mcc/mnc: {:mcc => #{@mcc.inspect}, :mnc => #{@mnc.inspect}}."
    sim_card = SimCard.with_mcc_mnc(@mcc, @mnc).first
    return sim_card if sim_card
    puts "Select card using mcc/mnc not found: {:mcc => #{@mcc.inspect}, :mnc => #{@mnc.inspect}}."
    SimCard.free_cards.first
  end
end
