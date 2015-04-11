require File.expand_path('../../../test_helper.rb',  __FILE__)

describe CardSelector do
  before(:each) do
    @card_selector = CardSelector.new(nil, nil, nil)
  end

  it 'select a sim_card should mark it, so it will not be select again for a while' do
    sim_card = SimCard.create
    @card_selector.stub(:select_card, sim_card) do
      selected = @card_selector.select_and_mark_card
      assert_equal 'marked', selected.status
    end
  end

  it 'select card with the requested mcc/mnc first' do
    sim_card = SimCard.create
    SimCard.stub(:with_mcc_mnc, Minitest::Mock.new.expect(:first, sim_card)) do
      selected = @card_selector.select_and_mark_card
      assert_equal sim_card, selected
    end
  end
end
