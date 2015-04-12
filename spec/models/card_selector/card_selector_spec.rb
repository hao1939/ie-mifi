require File.expand_path('../../../test_helper.rb',  __FILE__)

describe CardSelector do
  before(:each) do
    @user = User.all.first
    @card_selector = CardSelector.new(@user, nil, nil)
  end

  it 'select a sim_card should mark it, so it will not be select again for a while' do
    sim_card = SimCard.create
    @card_selector.stub(:select_card, sim_card) do
      selected = @card_selector.select_and_mark_card
      queried = SimCard.find(selected.id)
      assert_equal 'marked', queried.status
    end
  end

  it 'select static card assignment first' do
    sim_card = SimCard.create
    StaticCardAssignment.create(:user_id => @user.id, :sim_card_id => sim_card.id, :active_from => (Time.now - 1.day), :expire_on => (Time.now + 1.day))

    selected = @card_selector.select_and_mark_card
    assert_equal sim_card, selected
  end

  it 'the static card already been used by other user should unbind' do
    sim_card = SimCard.create(:status => 'free', :ready => true)
    pre_user = User.create
    pre_user.bind(sim_card)

    user = User.create
    statci_card_assignment = StaticCardAssignment.create(:user_id => user.id, :sim_card_id => sim_card.id, :active_from => (Time.now - 1.day), :expire_on => (Time.now + 1.day))

    assert_equal 1, CardBinding.where(:sim_card => sim_card, :active => true).size
    assert_equal 'used', sim_card.status

    card_selector = CardSelector.new(user, nil, nil)
    selected = card_selector.select_and_mark_card

    assert_equal selected, sim_card
    assert_equal 1, CardBinding.where(:sim_card => sim_card, :active => false).size
    # assert_equal 'free', sim_card.status
  end

  it 'select card with the requested mcc/mnc second' do
    sim_card = SimCard.create
    SimCard.stub(:with_mcc_mnc, Minitest::Mock.new.expect(:first, sim_card)) do
      selected = @card_selector.select_and_mark_card
      assert_equal sim_card, selected
    end
  end
end
