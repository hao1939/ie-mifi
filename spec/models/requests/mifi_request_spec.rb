require_relative '../../test_helper.rb'
require_relative '../../../app/models/requests/mifi_request.rb'
describe MifiRequest do
  include MyAppHelpers

  before(:each) do
    # this is a auth_request body
    request_body = "1\x04\xFF\xFF\xFF\x01'\x00\x88\x00\x81\"\x10\xABe%\xC5\x90Q\xD3\"\xEE&\x10\xBD\xE4)\xD1\x9D\x10\xD9\x01\xDB\x87A\x13rL\xFE1\xAE\xCA\xCD\x03K\x8F\b\x10\x82>>F:\xD7\xD4\x02\x01\x02\x02\x03\x04\x01\x05".b
    @io = StringIO.new(request_body)
  end

  it 'should be valid if mac was verified' do
    mifi_request = AuthRequest.new(*parse_body(@io))

    mifi_request.stub(:mac_key, "\x11\"3DUfw\x88\x99\xAA\xBB\xCC\xDD\xEE\xFF\x00".b) do
      assert mifi_request.valid?

      mifi_request.stub(:des3mac, false) do
        assert !mifi_request.valid?
      end
    end
  end

  it 'mac_key should comes from CardBinding' do
    expected_mac_key = 'this is mac_key'

    mifi_request = MifiRequest.new(*parse_body(@io))
    card_binding = Minitest::Mock.new
    card_binding.expect(:mac_key, expected_mac_key)

    mifi_request.stub('card_binding', card_binding) do
      assert_equal expected_mac_key, mifi_request.mac_key
    end
  end
end
