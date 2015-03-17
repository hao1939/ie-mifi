require File.expand_path('../../test_helper.rb',  __FILE__)

describe CardBinding do
  it 'insert and query from db' do
    card_binding = CardBinding.new

    assert card_binding.save
    assert_equal card_binding, CardBinding.find(card_binding.id)
  end
end
