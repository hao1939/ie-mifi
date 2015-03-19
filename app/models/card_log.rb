class CardLog < ActiveRecord::Base
  belongs_to :user
  belongs_to :card_binding
end
