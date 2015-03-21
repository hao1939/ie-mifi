describe SimCard do
  it 'save data_file to db' do
    data = "6F07090849061070359760956F600664F0108000FF6F7B0564F000FFFF2FF1090103010203040201"
    data_files = data.hex_to_bytes
    imsi = data_files[3..11]

    sim_card = SimCard.create!(:imsi=> imsi, :data_files => data_files)

    assert_equal data_files, sim_card.data_files
  end

  it '"g3_data": enabled sim_card should return data_files + 2FF1' do
    data = "6F07090849061070359760956F600664F0108000FF6F7B0564F000FFFF2FF1090103010203040201"
    expected_g3_date = data.hex_to_bytes

    xdata = "6F07090849061070359760956F600664F0108000FF6F7B0564F000FFFF"
    data_files = xdata.hex_to_bytes
    normal_2ff1 = "2FF1090103010203040201".hex_to_bytes

    sim_card = SimCard.create!(:enabled => true, :file_2ff1 => normal_2ff1, :data_files => data_files)

    assert_equal expected_g3_date, sim_card.g3_data
  end

  it '"g3_data": not enabled sim_card should replace the 2FF1 with initial data' do
    # data = "6F07090849061070359760956F600664F0108000FF6F7B0564F000FFFF2FF1090103010203040201"
    data = "6F07090849061070359760956F600664F0108000FF6F7B0564F000FFFF"
    data_files = data.hex_to_bytes
    normal_2ff1 = "2FF1090103010203040201".hex_to_bytes

    init_file_2ff1 = "initial"
    expected_g3_date = data_files + init_file_2ff1

    sim_card_init = SimCardInit.create(:mcc_mnc => 'mcc_mnc', :file_2ff1 => init_file_2ff1)
    sim_card = SimCard.create!(:enabled => false, :mcc_mnc => 'mcc_mnc', :file_2ff1 => normal_2ff1, :data_files => data_files)

    assert_equal expected_g3_date, sim_card.g3_data
  end

  it 'set_enabled! should set enabled to true and save to db' do
    sim_card = SimCard.create
    assert !sim_card.enabled?
    sim_card.set_enabled!

    queried = SimCard.find(sim_card.id)
    assert queried.enabled?
  end
end
