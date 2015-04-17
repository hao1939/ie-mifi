require_relative '../../app/models/card_binding.rb'
class CardGarbageWorker
  include ::Sidekiq::Worker
  sidekiq_options :queue => :default

  def perform
    CardBinding.freezing_card_bindings.each do |b|
      puts "Deactivate CardBinding: {:user_id => #{b.user_id}, :sim_card_id => #{b.sim_card_id}}"
      b.deactivate!
    end
  end
end
