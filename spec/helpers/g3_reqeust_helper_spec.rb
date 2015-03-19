require File.expand_path('../../test_helper.rb',  __FILE__)

describe G3RequestHelpers do
  include G3RequestHelpers

  it 'bind_card should unbind then bind' do
    @user = Minitest::Mock.new
    @user.expect(:unbind, true)
    @user.expect(:bind, true, [@sim_card])

    bind_card(@user, @sim_card)

    @user.verify
  end

  it 'select a sim_card should mark it, so it will not be select again for a while' do
    sim_card = SimCard.create
    SimCard.stub(:free_cards, [sim_card]) do
      sim_card = select_an_avaliable_card
      assert_equal 'marked', sim_card.status
    end
  end
end
