describe SimCard do
  it 'save data_file to db' do
    data = "6F07090849061070359760956F600664F0108000FF6F7B0564F000FFFF2FF1090103010203040201"
    data_files = data.scan(/../).map { |x| x.hex }.pack('c*')
    imsi = data_files[3..11]

    sim_card = SimCard.create!(:imsi=> imsi, :data_files => data_files)

    assert_equal data_files, sim_card.data_files
  end
end
