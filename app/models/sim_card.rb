class SimCard
  def g3
    data = "112233445566778899AABBCCDDEEFF006F07090849061070359760956F600664F0108000FF6F7B0564F000FFFF2FF1090103010203040201"
    data.scan(/../).map { |x| x.hex }.pack('c*')
  end
end
