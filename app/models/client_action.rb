class ClientAction < ActiveRecord::Base
  belongs_to :user

  def mark_delivered!
    self.delivered = true
    save!
  end
end
