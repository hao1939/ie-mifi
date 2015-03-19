class SimCard < ActiveRecord::Base
  def self.free_cards
    SimCard.where(status: 'free')
  end

  def mark
    self.status = 'marked'
  end
end
