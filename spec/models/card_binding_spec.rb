require_relative '../test_helper.rb'
require_relative '../../app/models/card_binding.rb'

describe CardBinding do
  it 'insert and query from db' do
    card_binding = CardBinding.new

    assert card_binding.save
    assert_equal card_binding, CardBinding.find(card_binding.id)
  end

  it 'create a CardBinding should default be "active"' do
    card_binding = CardBinding.create
    assert card_binding.active?
  end

  it 'create a CardBinding should mark the SimCard as "used"' do
    sim_card = SimCard.create
    # marked
    sim_card.mark!

    card_binding = CardBinding.create(:sim_card => sim_card)

    query_sim_card = SimCard.find(sim_card.id)
    assert_equal 'used', query_sim_card.status
  end

  it 'deactivate! should set active? to false' do
    card_binding = CardBinding.create

    assert card_binding.active?
    card_binding.deactivate!
    assert !card_binding.active?
  end

  it 'deactivate! should mark sim_card as "free"' do
    sim_card = SimCard.create
    card_binding = CardBinding.create(:sim_card => sim_card)

    card_binding.deactivate!

    query_sim_card = SimCard.find(sim_card.id)
    assert_equal 'free', query_sim_card.status
  end

  it 'get sim_card' do
    sim_card = SimCard.create
    card_binding = CardBinding.create(:sim_card => sim_card)

    assert card_binding.sim_card.is_a?(SimCard)
  end

  it 'active_card_bindings' do
    card_binding = CardBinding.create(:active => true)
    active_card_bindings = CardBinding.active_card_bindings
    assert_equal 1, active_card_bindings.size
    assert_equal card_binding, active_card_bindings.first
  end

  it 'freezing_card_bindings are active card_binding which not be touched in 15 minutes' do
    card_binding = CardBinding.create(:active => true, :updated_at => Time.now - 15.minutes)
    freezing_card_bindings = CardBinding.freezing_card_bindings
    assert_equal 1, freezing_card_bindings.size

    card_binding.touch
    freezing_card_bindings = CardBinding.freezing_card_bindings
    assert_equal 0, freezing_card_bindings.size
  end
end
