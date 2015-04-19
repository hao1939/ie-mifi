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
    puts "Query static card assignment for user, loc: #{@user.id}, #{@mcc.inspect}"
    static_card_assignment = StaticCardAssignment.active_assignment_for_loc(@user.id, @mcc)
    if static_card_assignment
      sim_card = SimCard.find(static_card_assignment.sim_card_id)
      CardBinding.where(:sim_card => sim_card).each {|b| b.deactivate!}
      return sim_card if sim_card
    end
    puts "Query static card assignment for user/loc not found: #{@user.id}, #{@mcc.inspect}"
    puts "--Select card using mcc/mnc: {:mcc => #{@mcc.inspect}, :mnc => #{@mnc.inspect}}."
    SimCard.with_mcc_mnc(@mcc, @mnc).each do |sim_card|
      return sim_card if sim_card.avaliable_for?(@mcc)
    end
    puts "--Select card using mcc/mnc not found: {:mcc => #{@mcc.inspect}, :mnc => #{@mnc.inspect}}."
    SimCardPrice.where(:loc_mcc => @mcc.b).each do |sim_card_price|
      puts "----Query #{sim_card_price.card_mcc.inspect}, #{sim_card_price.card_mnc.inspect}"
      SimCard.with_mcc_mnc(sim_card_price.card_mcc, sim_card_price.card_mnc).each do |sim_card|
        return sim_card if sim_card.avaliable_for?(@mcc)
      end
    end
    nil
  end
end
