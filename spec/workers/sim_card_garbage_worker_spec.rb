require 'sidekiq'
require_relative '../test_helper.rb'
require_relative '../../app/workers/card_garbage_worker.rb'

describe CardGarbageWorker do
  freezing_card_bindings = (3+rand(9)).times.map do |i|
    mock = Minitest::Mock.new
    mock.expect(:deactivate!, true)
    mock.expect(:user_id, i)
    mock.expect(:sim_card_id, i)
  end
  CardBinding.stub(:freezing_card_bindings, freezing_card_bindings) do
    card_garbage_worker = CardGarbageWorker.new
    card_garbage_worker.perform
  end
  freezing_card_bindings.each {|c| c.verify}
end
