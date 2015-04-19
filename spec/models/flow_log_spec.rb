require_relative '../test_helper.rb'
require_relative '../../app/models/flow_log.rb'
describe FlowLog do
  it 'save and query from database' do
    flow_log = FlowLog.new(:user_id => '0xFFFFFF01'.to_i(16), :count => '0xFFFFFFFF'.to_i(16))

    assert flow_log.save!

    flow_log.destroy!
  end
end
