require_relative '../../test_helper.rb'
require_relative '../../../app/models/card_selector/static_card_assignment.rb'
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

  it 'active_assignment_for_loc' do
    loc_mcc = 'mc'
    sim_card = SimCard.create(:mcc => 'mc', :mnc => 'c')
    static_card_assignment = StaticCardAssignment.create(:user_id => 0, :sim_card_id => sim_card.id, :active_from => (Time.now - 1.day), :expire_on => (Time.now + 1.day))

    assert_equal 1, StaticCardAssignment.active_assignment_for(0).size
    assert_equal nil, StaticCardAssignment.active_assignment_for_loc(0, loc_mcc)

    SimCardPrice.create(:loc_mcc => loc_mcc, :card_mcc => sim_card.mcc, :card_mnc => sim_card.mnc, :local => true)
    assert_equal static_card_assignment, StaticCardAssignment.active_assignment_for_loc(0, loc_mcc)
  end
end
