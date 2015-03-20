require_relative 'test_helper.rb'

describe MyApp do
  it 'test_it_says_hello_world' do
    get '/'
    assert last_response.ok?
    assert_equal 'Hello ieMiFi!', last_response.body
  end

  include MifiCrypt

  before(:all) do
    # default there is a user with :id => '0xFFFFFF01'.to_i(16)
    # user = User.find_or_careate(:user_id => '0xFFFFFF01'.to_i(16))
    sim_card = SimCard.create!
    CardBinding.create!(:user_id => '0xFFFFFF01'.to_i(16),
      :sim_card_id => sim_card.id,
      :mac_key => "\x11\"3DUfw\x88\x99\xAA\xBB\xCC\xDD\xEE\xFF\x00".b)
  end

  it 'test_3g_request' do
    skey = "\b\x05\x05\x05\a\x02>\x15g\x97\x04\xC2\x0E%\x80\xC4\xB5\xA2\xE7\xBBa\xAF\xB0x\xC0\x00\x00\x00\x00\x00\x00\x00\x00\x99\x00\x00\x99\x00\x00\x99\x00\x9C\xFE14\x811z\x7F\xA6\xDD\xFC\x11\xA5\xFC=\xD0\x86Ra\x1C\x9Aa{\x06\xD6\xA0\xCA\xBA\xC0Ij4\n\xE8\xE4w/\xE5\x95\xC6\xBA\n\n\xBA\n\x00\xB0\xB0\xD4\xAC\xF7x\x97b\xBA1\xCCqz\x9F3{\xE6\xF7y\xEAlZ\xFE\x89E4\x1C\xC5r\xE2\xEF\xCE\xBB\x16\xD4\x9C\x9C\xD4\x9C\x00HH\xCD\xB9\xD4%\x19\xD0:\xAB\xDB,\xBB=\a\x04%\x80\xC4\xB5\xA2\x13\x99\x8A\x13\x13\x00#\xBA\x00\x82U0\xE7\xE7\xCE:'*\x1EEVq\xE9q\xD0oV\x00\xE99'\x00\xBFV\xCE9'\x86\xF79\xE9\xE9\xE9\x98\xE9qq\x98)f\x10\xEA\xBFo\x00\xE0U\x13*\xE3:\x85\xB6_\x9Cl\xDA\x00\xD9\x8Fv3\x86#\x19\x85\xBCF\\\x85\xA5\xE0e: \x9F_:EEE\x85E\xC0\xC0\x85\xD2\x9A\eu\xD4\xFD\x84\xC5\x94\xBC\x1A\x0F\xA2\xE0\xC0=\x0F\xE6\a\xFD\ayr\xCA\xA2\x82\xEB \xF5\x8FX\x1C\xE8/GU\x80I\x10U\xC73\xC5h1\xAF\xADh\xF4\xF4\xF4\xF6\xF4\x02\x02\xF6"
    pkey = "\b\n\f\x02\xC2\x0E\xA3\xD4\xC2T\x96\xCD\xB9\xD4%\x19\xD0:x\xC0\a\x04\xF9\x00\xF9\x00\x00\xF9\xF9\xF9\xE0\xF3\x13\xF3\n\x13\x13\x19\xB6_\x10U\xB5\xE9\x10\xAF\x853V\x7F\xC3O\xA5*\xEAv\xD9Uo\xBFE\xCA\xC9\xB50\x03l\x7Fu\x7F\xF9l\xE0\xC3\xF3\xE0\xE9\x1AolVE#\xDAU\t\xB6\x9C\x8C\xC9\x13\xBC\x00\xD9\xF000\xDA\xE9\xD3\xC3\x9C\xA5o\xB6\xACv\x8C_\x00\x8C\x00\x8C\x00\x00\x8C\x8C\x8C\x03twt\xF8ww\x8FL\t\xC9\xF1\xF2E\xC9\xC3\x16\xB1\xA4\xCF{+\xD0\xD5\xF9\x8BJ\xF3\xEF\xE1\xD3\xD4\x83\x19\r\xBE\xBA$\xDE\xCDG\xF4\x86\xDE8\x86\xC0\x11\x90*b&D3\xF6\xF0.H\xD1~P\xF1\xF8\x9DvS\b\x93\xFB\xDA\x9D\x90\xA7\e~\x9E\xFC m*\xB2\xDAa\x983\x8D\xC2\xE0\xC5\xB0\xCA\v<\xCC50\xC1\b\x00\x11\x00\xC0\x00\xC0\"\x01P\x04\b\xE1\t!"

    request_body = "1\x04\xFF\xFF\xFF\x01\x02\x00\x00\b\x01\x02\x03\x04\x05\x06\a\b\x04\x00\x00\x00\x01\x03d\xF0\x10\x02\x11\"\x023D\x01U\b\xE3%\xA7\xB0c\x0E\x88\xC0\x13\x8D\x03\x0FN\xC4\xFBw\x85\xEF \xF4^\x9A\xC2\x86/\xF2f\xDC\xE6\b\n\f\x02\xC2\x0E\xA3\xD4\xC2T\x96\xCD\xB9\xD4%\x19\xD0:x\xC0\a\x04\xF9\x00\xF9\x00\x00\xF9\xF9\xF9\xE0\xF3\x13\xF3\n\x13\x13\x19\xB6_\x10U\xB5\xE9\x10\xAF\x853V\x7F\xC3O\xA5*\xEAv\xD9Uo\xBFE\xCA\xC9\xB50\x03l\x7Fu\x7F\xF9l\xE0\xC3\xF3\xE0\xE9\x1AolVE#\xDAU\t\xB6\x9C\x8C\xC9\x13\xBC\x00\xD9\xF000\xDA\xE9\xD3\xC3\x9C\xA5o\xB6\xACv\x8C_\x00\x8C\x00\x8C\x00\x00\x8C\x8C\x8C\x03twt\xF8ww\x8FL\t\xC9\xF1\xF2E\xC9\xC3\x16\xB1\xA4\xCF{+\xD0\xD5\xF9\x8BJ\xF3\xEF\xE1\xD3\xD4\x83\x19\r\xBE\xBA$\xDE\xCDG\xF4\x86\xDE8\x86\xC0\x11\x90*b&D3\xF6\xF0.H\xD1~P\xF1\xF8\x9DvS\b\x93\xFB\xDA\x9D\x90\xA7\e~\x9E\xFC m*\xB2\xDAa\x983\x8D\xC2\xE0\xC5\xB0\xCA\v<\xCC50\xC1\b\x00\x11\x00\xC0\x00\xC0\"\x01P\x04\b\xE1\t!".b

    sim_card = SimCard.create(:data_files => "everything fine.")
    SimCard.stub(:free_cards, [sim_card]) do
      post '/3g', request_body, "CONTENT_TYPE"=>"application/octet-stream"
    end

    assert last_response.ok?

    body = last_response.body
    content_without_version = body[1..-1]
    decrypted = pk_decrypt(skey, content_without_version)
    g3_date = decrypted[16..-1]
    assert_equal "everything fine.", g3_date
  end

  it 'test_auth_request' do
    request_body = "1\x04\xFF\xFF\xFF\x01'\x00\x88\x00\x81\"\x10\xABe%\xC5\x90Q\xD3\"\xEE&\x10\xBD\xE4)\xD1\x9D\x10\xD9\x01\xDB\x87A\x13rL\xFE1\xAE\xCA\xCD\x03K\x8F\b\x10\x82>>F:\xD7\xD4\x02\x01\x02\x02\x03\x04\x01\x05".b
    post '/auth', request_body, "CONTENT_TYPE"=>"application/octet-stream"

    assert_equal 200, last_response.status
  end

  it 'test_beat_request' do
    request_body =  "1\x04\xFF\xFF\xFF\x01\x04\x01\x02\x03\x04\b\x88\x15L\xE6\xBD\xBD\xF1\x90\x010\x02\x11\"\x023D\x01U".b
    post '/beats', request_body, "CONTENT_TYPE"=>"application/octet-stream"

    assert_equal 200, last_response.status
    assert_equal "\x00\x00", last_response.body
  end

  it 'test /beat with pending action to be delivered' do
    request_body =  "1\x04\xFF\xFF\xFF\x01\x04\x01\x02\x03\x04\b\x88\x15L\xE6\xBD\xBD\xF1\x90\x010\x02\x11\"\x023D\x01U".b
    pending_actions = [{:cmd => 'action1'}, {:cmd => 'action2'}]
    user = User.find('0xFFFFFF01'.to_i(16))

    ClientAction.create(:user => user, :cmd => 'action1')
    ClientAction.create(:user => user, :cmd => 'action2')
    expected_response_body = 'action1action2'

    post '/beats', request_body, "CONTENT_TYPE"=>"application/octet-stream"

    assert_equal 200, last_response.status
    assert_equal expected_response_body, last_response.body
  end

  it 'test /log request' do
    request_body = "1\x04\xFF\xFF\xFF\x01\x06\x15\x03\x12 0\x01\b"+ "\xAAg*&\xF9\xEC\x0EF"+ "this is test log\r\nyou check log\x00".b
    post '/log', request_body, "CONTENT_TYPE"=>"application/octet-stream"

    assert_equal 200, last_response.status
  end
end
