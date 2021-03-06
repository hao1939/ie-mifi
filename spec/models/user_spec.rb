require_relative '../test_helper.rb'
require_relative '../../app/models/user.rb'
describe User do
  it 'save and query from database' do
    pkey = "\b\n\f\x02\xC2\x0E\xA3\xD4\xC2T\x96\xCD\xB9\xD4%\x19\xD0:x\xC0\a\x04\xF9\x00\xF9\x00\x00\xF9\xF9\xF9\xE0\xF3\x13\xF3\n\x13\x13\x19\xB6_\x10U\xB5\xE9\x10\xAF\x853V\x7F\xC3O\xA5*\xEAv\xD9Uo\xBFE\xCA\xC9\xB50\x03l\x7Fu\x7F\xF9l\xE0\xC3\xF3\xE0\xE9\x1AolVE#\xDAU\t\xB6\x9C\x8C\xC9\x13\xBC\x00\xD9\xF000\xDA\xE9\xD3\xC3\x9C\xA5o\xB6\xACv\x8C_\x00\x8C\x00\x8C\x00\x00\x8C\x8C\x8C\x03twt\xF8ww\x8FL\t\xC9\xF1\xF2E\xC9\xC3\x16\xB1\xA4\xCF{+\xD0\xD5\xF9\x8BJ\xF3\xEF\xE1\xD3\xD4\x83\x19\r\xBE\xBA$\xDE\xCDG\xF4\x86\xDE8\x86\xC0\x11\x90*b&D3\xF6\xF0.H\xD1~P\xF1\xF8\x9DvS\b\x93\xFB\xDA\x9D\x90\xA7\e~\x9E\xFC m*\xB2\xDAa\x983\x8D\xC2\xE0\xC5\xB0\xCA\v<\xCC50\xC1\b\x00\x11\x00\xC0\x00\xC0\"\x01P\x04\b\xE1\t!"
    user = User.new(:id => '0xFFF0FF01'.to_i(16))
    user.pkey = pkey
    user.save!

    queried = User.find(user.id)
    assert_equal pkey, queried.pkey

    user.destroy!
  end

  it 'unbind should deactivate old card_usages' do
    sim_card = Minitest::Mock.new
    sim_card.expect(:deactivate!, true)

    user = User.create
    user.stub(:card_bindings, [sim_card]) do
      user.unbind
    end

    sim_card.verify
  end

  it 'card_usages should return all binded card_usages' do
    sim_cards = []
    (1..rand(3..5)).each {sim_cards << SimCard.create}

    user = User.create
    card_bindings = sim_cards.map {|card| CardBinding.create(:sim_card_id => card.id, :user_id => user.id)}

    assert_equal card_bindings, user.card_bindings
  end

  it 'bind should create an instance of CardBinding' do
    sim_card = SimCard.create
    user = User.first

    card_binding = user.bind(sim_card)

    assert card_binding.is_a?(CardBinding)
    assert card_binding.active?
  end

  it 'bind should create a random mac_key for CardBinding' do
    user = User.create(:id => '0xFFFF0F01'.to_i(16))
    sim_card = SimCard.create

    card_binding = user.bind(sim_card)
    assert_equal 16, card_binding.mac_key.length
  end

  it 'pending_actions should return not delivered client actions' do
    user = User.create(:id => '0xFF00F01'.to_i(16))
    client_action = ClientAction.create(:user => user)

    assert user.pending_actions.include?(client_action)
    assert !client_action.delivered?
  end
end
