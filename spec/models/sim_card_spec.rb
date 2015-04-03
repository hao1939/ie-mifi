require_relative '../test_helper.rb'

describe SimCard do
  it 'save data_file to db' do
    data = "6F07090849061070359760956F600664F0108000FF6F7B0564F000FFFF2FF1090103010203040201"
    data_files = data.hex_to_bytes
    imsi = data_files[3..11]

    sim_card = SimCard.create!(:imsi=> imsi, :data_files => data_files)

    assert_equal data_files, sim_card.data_files
  end

  it '"g3_data": enabled sim_card should return data_files + 2FF1' do
    data = "6F07090849061070359760956F600664F0108000FF6F7B0564F000FFFF"
    data_files = data.hex_to_bytes
    normal_2ff1 = "normal_2ff1".hex_to_bytes

    expected_g3_date = data_files + normal_2ff1

    sim_card_init = MiniTest::Mock.new
    sim_card_init.expect(:file_2ff1, normal_2ff1)
    SimCardInit.stub(:where, [sim_card_init]) do
      sim_card = SimCard.create!(:network_enabled => true, :data_files => data_files)
      assert_equal expected_g3_date, sim_card.g3_data
    end
  end

  it '"g3_data": not enabled sim_card should replace the 2FF1 with initial data' do
    data = "6F07090849061070359760956F600664F0108000FF6F7B0564F000FFFF"
    data_files = data.hex_to_bytes

    init_file_2ff1 = "init_file_2ff1"
    expected_g3_date = data_files + init_file_2ff1

    sim_card_init = MiniTest::Mock.new
    sim_card_init.expect(:init_file_2ff1, init_file_2ff1)
    SimCardInit.stub(:where, [sim_card_init]) do
      sim_card = SimCard.create!(:network_enabled => false, :data_files => data_files)
      assert_equal expected_g3_date, sim_card.g3_data
    end
  end

  it 'set_network_enabled! should set enabled to true and save to db' do
    sim_card = SimCard.create
    assert !sim_card.network_enabled?
    sim_card.set_network_enabled!

    queried = SimCard.find(sim_card.id)
    assert queried.network_enabled?
  end
end
