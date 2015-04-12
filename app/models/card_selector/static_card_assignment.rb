class StaticCardAssignment < ActiveRecord::Base
  scope :active, -> {where('? between active_from and expire_on', Time.now)}
  scope :active_assignment_for, ->(user_id) {active.where(:user_id => user_id)}
end
