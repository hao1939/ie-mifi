require_relative './sim_card.rb'
class CardBinding < ActiveRecord::Base
  scope :active_card_bindings, -> { where(active: true) }
  scope :freezing_card_bindings, -> { active_card_bindings.where('updated_at < ?', Time.now - 15.minutes) }
  # TODO we should refactoring the create, so we can do transaction
  belongs_to :user
  belongs_to :sim_card

  after_create :mark_sim_card_used
  def mark_sim_card_used
    sim_card && (sim_card.status = 'used') && sim_card.save!
  end

  def deactivate!
    sim_card && (sim_card.status = 'free') && sim_card.save!
    self.active = false
    save!
  end
end
