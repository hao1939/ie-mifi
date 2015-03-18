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

end
