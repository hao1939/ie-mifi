require_relative '../../test_helper.rb'
require_relative '../../../app/models/requests/auth_request.rb'
describe AuthRequest do
  include MyAppHelpers

  before(:each) do
    request_body = "1\x04\xFF\xFF\xFF\x01'\x00\x88\x00\x81\"\x10\xABe%\xC5\x90Q\xD3\"\xEE&\x10\xBD\xE4)\xD1\x9D\x10\xD9\x01\xDB\x87A\x13rL\xFE1\xAE\xCA\xCD\x03K\x8F\b\x10\x82>>F:\xD7\xD4\x02\x01\x02\x02\x03\x04\x01\x05".b
    @io = StringIO.new(request_body)
  end
end
