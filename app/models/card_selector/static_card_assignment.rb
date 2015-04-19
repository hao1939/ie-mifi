require_relative '../sim_card.rb'
class StaticCardAssignment < ActiveRecord::Base
  scope :active, -> {where('? between active_from and expire_on', Time.now)}
  scope :active_assignment_for, ->(user_id) {active.where(:user_id => user_id)}

  def self.active_assignment_for_loc(user_id, mcc)
    active_assignment_for(user_id).each do |static_card_assignment|
      sim_card = SimCard.find(static_card_assignment.sim_card_id)
      return static_card_assignment if sim_card.avaliable_for?(mcc)
    end
    nil
  end
end
