require 'securerandom'

class User < ActiveRecord::Base
  self.primary_key = "id"

  def bind(sim_card)
    mac_key = SecureRandom.random_bytes(16)
    CardBinding.create(:user => self, :sim_card => sim_card, :mac_key => mac_key)
  end

  def card_bindings
    CardBinding.where(active: true, user_id: id)
  end

  def unbind
    card_bindings.each {|b| b.deactivate! }
  end

  def create_card_usage
    true
  end
end
