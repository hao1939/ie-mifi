require File.expand_path('../../../test_helper.rb',  __FILE__)
describe StaticCardAssignment do
  it 'active' do
    static_card_assignment = StaticCardAssignment.create(:user_id => 0, :sim_card_id => 0, :active_from => (Time.now - 1.day), :expire_on => (Time.now + 1.day))
    active_assignments = StaticCardAssignment.active.all
    assert active_assignments.include?(static_card_assignment)

    static_card_assignment = StaticCardAssignment.create(:user_id => 0, :sim_card_id => 0, :active_from => (Time.now + 10.minute), :expire_on => (Time.now + 1.day))
    active_assignments = StaticCardAssignment.active.all
    assert !active_assignments.include?(static_card_assignment)

    static_card_assignment = StaticCardAssignment.create(:user_id => 0, :sim_card_id => 0, :active_from => (Time.now - 1.day), :expire_on => Time.now)
    active_assignments = StaticCardAssignment.active.all
    assert !active_assignments.include?(static_card_assignment)
  end

  it 'active_assignment_for' do
    StaticCardAssignment.create(:user_id => 0, :sim_card_id => 0, :active_from => (Time.now - 1.day), :expire_on => (Time.now + 1.day))
    StaticCardAssignment.create(:user_id => 0, :sim_card_id => 0, :active_from => (Time.now - 1.day), :expire_on => Time.now)
    assert_equal 1, StaticCardAssignment.active_assignment_for(0).size
    assert_equal 0, StaticCardAssignment.active_assignment_for(1).size
  end
end
