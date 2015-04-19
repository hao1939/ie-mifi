require_relative '../../test_helper.rb'
require_relative '../../../app/models/requests/g3_request.rb'
describe G3Request do
  include MyAppHelpers

  it 'test_parse_3g_request' do
    request_body = "1\x04\xFF\xFF\xFF\x01\x02\x00\x00\b\x01\x02\x03\x04\x05\x06\a\b\x04\x00\x00\x00\x01\x03d\xF0\x10\x02\x11\"\x023D\x01U\b\xE3%\xA7\xB0c\x0E\x88\xC0\x13\x8D\x03\x0FN\xC4\xFBw\x85\xEF \xF4^\x9A\xC2\x86/\xF2f\xDC\xE6\b\n\f\x02\xC2\x0E\xA3\xD4\xC2T\x96\xCD\xB9\xD4%\x19\xD0:x\xC0\a\x04\xF9\x00\xF9\x00\x00\xF9\xF9\xF9\xE0\xF3\x13\xF3\n\x13\x13\x19\xB6_\x10U\xB5\xE9\x10\xAF\x853V\x7F\xC3O\xA5*\xEAv\xD9Uo\xBFE\xCA\xC9\xB50\x03l\x7Fu\x7F\xF9l\xE0\xC3\xF3\xE0\xE9\x1AolVE#\xDAU\t\xB6\x9C\x8C\xC9\x13\xBC\x00\xD9\xF000\xDA\xE9\xD3\xC3\x9C\xA5o\xB6\xACv\x8C_\x00\x8C\x00\x8C\x00\x00\x8C\x8C\x8C\x03twt\xF8ww\x8FL\t\xC9\xF1\xF2E\xC9\xC3\x16\xB1\xA4\xCF{+\xD0\xD5\xF9\x8BJ\xF3\xEF\xE1\xD3\xD4\x83\x19\r\xBE\xBA$\xDE\xCDG\xF4\x86\xDE8\x86\xC0\x11\x90*b&D3\xF6\xF0.H\xD1~P\xF1\xF8\x9DvS\b\x93\xFB\xDA\x9D\x90\xA7\e~\x9E\xFC m*\xB2\xDAa\x983\x8D\xC2\xE0\xC5\xB0\xCA\v<\xCC50\xC1\b\x00\x11\x00\xC0\x00\xC0\"\x01P\x04\b\xE1\t!".b
    @io = StringIO.new(request_body)
    g3_request = G3Request.new(*parse_body(@io))

    assert g3_request.valid?

    g3_request.stub(:des3mac, false) do
      assert !g3_request.valid?
    end

    g3_request.stub(:digest_valid?, false) do
      assert !g3_request.valid?
    end
  end
end
