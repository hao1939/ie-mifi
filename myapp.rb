require 'sinatra/base'
require 'sinatra/activerecord'
require 'mifi_crypt'
require 'mifi/card_reader'

Mifi::CardReader.use_net_reader

require File.expand_path('../lib/utils.rb', __FILE__)
Dir.glob(File.expand_path('../app/helpers/*.rb', __FILE__)).each { |r| require r}

require File.expand_path('../app/models/sim_card.rb', __FILE__)
require File.expand_path('../app/models/requests/mifi_request.rb', __FILE__)
require File.expand_path('../app/models/requests/g3_request.rb', __FILE__)
require File.expand_path('../app/models/requests/auth_request.rb', __FILE__)
require File.expand_path('../app/models/requests/beat_request.rb', __FILE__)
require File.expand_path('../app/models/requests/log_request.rb', __FILE__)
require File.expand_path('../app/models/user.rb', __FILE__)
require File.expand_path('../app/models/flow_log.rb', __FILE__)
require File.expand_path('../app/models/card_binding.rb', __FILE__)

require File.expand_path('../app/models/card_selector/card_selector.rb', __FILE__)

class MyApp < Sinatra::Base
  API_VERSION = '1'

  require 'logger'
  ::Logger.class_eval { alias :write :'<<' }
  access_log = ::File.join(::File.dirname(::File.expand_path(__FILE__)), 'public', 'log.txt')
  logger = ::Logger.new(access_log)
  error_logger = ::File.new(::File.join(::File.dirname(::File.expand_path(__FILE__)), 'public', 'error.log'), "a+")
  error_logger.sync = true

  configure do
    use ::Rack::CommonLogger, logger
  end

  before {
    env["rack.errors"] =  error_logger
  }

  configure :development, :test do
    require 'pry'
    set :show_exceptions, false
  end

  register Sinatra::ActiveRecordExtension
  helpers MyAppHelpers
  helpers MifiCrypt

  error NoMoreSimCard do
    [501, 'no more sim_card!']
  end
  error Mifi::CardError do
    [410, 'card error!']
  end

  get '/' do
    "Hello ieMiFi!"
  end

  before do
    @data = parse_body(request.body)
    raw = @data[1]
    logger.info "#{request.path} REQUEST : #{raw.unpack('H*')[0]}"
  end

  after do
    logger.info "#{request.path} RESPONSE: #{response.body.join.unpack('H*')[0]}"
  end

  post '/3g' do
    g3_request = G3Request.new(*@data)
    halt(400, 'sign error!') unless g3_request.valid?
    @pkey = g3_request.pkey
    @user = g3_request.user
    if @user.card_bindings.empty?
      @card_selector = CardSelector.new(@user,  g3_request.mcc, g3_request.mnc)
      @card = @card_selector.select_and_mark_card
      @card_binding = bind_card(@user, @card)
    else
      @card_binding = @user.card_bindings.first
      @card = @card_binding.sim_card
    end
    res_before_encyrpt = @card_binding.mac_key + @card.g3_data
    logger.info "/3g RESPONSE before encrypt: #{res_before_encyrpt.b.unpack('H*')[0]}"
    API_VERSION + pk_encrypt(@pkey, res_before_encyrpt)
  end

  post '/auth' do
    auth_request = AuthRequest.new(*@data)
    halt(400, 'sign error!') unless auth_request.valid?
    @sim_card = auth_request.card_binding.sim_card
    auth_res = Mifi::CardReader.auth(@sim_card.card_addr, auth_request.auth_req)
    API_VERSION + auth_res.length.chr + auth_res
  end

  post '/beats' do
    beat_request = BeatRequest.new(*@data)
    @user = beat_request.user
    halt(400, 'sign error!') unless beat_request.valid?
    flow_log = FlowLog.new(:user_id => beat_request.user.id, :count => beat_request.count)
    flow_log.save!
    @sim_card = @user.card_bindings.first.sim_card
    @sim_card.set_network_enabled!
    halt(API_VERSION + "\x00\x00") if @user.pending_actions.empty?
    @user.pending_actions.each {|a| a.mark_delivered!} # TODO
    API_VERSION + @user.pending_actions.map(&:cmd).join
  end

  post '/log' do
    log_request = LogRequest.new(*@data)
    logger.info "LOG TEXT: #{log_request.text}"
    halt(400, 'sign error!') unless log_request.valid?
    log_request.save_card_log
    API_VERSION + "\x00\x00"
  end
end

