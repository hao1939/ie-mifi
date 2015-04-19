require_relative '../../test_helper.rb'
require_relative '../../../app/models/requests/log_request.rb'
describe LogRequest do
  include MyAppHelpers

  it 'test_parse_3g_request' do
    request_body = "3104ffffff040615031220300108a811be41813548cc746869732069732074657374206c6f670d0a796f7520636865636b206c6f6700".hex_to_bytes
    @io = StringIO.new(request_body)
    log_request = LogRequest.new(*parse_body(@io))

    assert_equal "this is test log\r\nyou check log\x00", log_request.text
  end
end
