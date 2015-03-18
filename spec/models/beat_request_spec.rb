require_relative '../test_helper.rb'

describe BeatRequest do
  include MyAppHelpers

  before(:each) do
    request_body =  "1\x04\xFF\xFF\xFF\x01\x04\x01\x02\x03\x04\b\x88\x15L\xE6\xBD\xBD\xF1\x90\x010\x02\x11\"\x023D\x01U".b
    @io = StringIO.new(request_body)
  end

  it 'should be valid if mac was verified' do
    beat_request = BeatRequest.new(*parse_body(@io))

    beat_request.stub(:mac_key, "\x11\"3DUfw\x88\x99\xAA\xBB\xCC\xDD\xEE\xFF\x00".b) do
      assert beat_request.valid?

      beat_request.stub(:des3mac, false) do
        assert !beat_request.valid?
      end
    end
  end
end
