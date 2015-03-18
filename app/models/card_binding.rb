class CardBinding < ActiveRecord::Base
  def deactivate!
    self.active = false
    save!
  end
end
