require File.expand_path('../../test_helper.rb',  __FILE__)

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
    sim_card.mark

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
end
