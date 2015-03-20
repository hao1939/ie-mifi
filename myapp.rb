require 'sinatra/base'
require 'sinatra/activerecord'
require 'mifi_crypt'

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

class MyApp < Sinatra::Base
  register Sinatra::ActiveRecordExtension

  configure :development, :test do
    require 'pry'
  end

  helpers MyAppHelpers
  helpers G3RequestHelpers

  include MifiCrypt

  get '/' do
    "Hello ieMiFi!"
  end

  before do
    @data = parse_body(request.body)
  end

  before '/3g' do
    @mifi_request = G3Request.new(*@data)
    halt(400, 'sign error!') unless @mifi_request.valid?
    @pkey = @mifi_request.pkey
  end

  post '/3g' do
    @user = @mifi_request.user
    @card = select_an_avaliable_card
    @card_binding = bind_card(@user, @card)
    '1' + pk_encrypt(@pkey, @card_binding.mac_key + @card.g3_data)
  end

  post '/auth' do
    auth_request = AuthRequest.new(*@data)
puts auth_request.inspect
    halt(400, 'sign error!') unless auth_request.valid?
    'SW1SW2'
  end

  post '/beats' do
    beat_request = BeatRequest.new(*@data)
    @user = beat_request.user
puts beat_request.inspect
    halt(400, 'sign error!') unless beat_request.valid?
    flow_log = FlowLog.new(:user_id => beat_request.user.id, :count => beat_request.count)
    flow_log.save!
    halt("\x00\x00") if @user.pending_actions.empty?
    @user.pending_actions.each {|a| a.mark_delivered!} # TODO
    @user.pending_actions.map(&:cmd).join
  end

  post '/log' do
    log_request = LogRequest.new(*@data)
puts log_request.inspect
    halt(400, 'sign error!') unless log_request.valid?
    log_request.save_card_log
    "\x00" + "\x09" + 'Hi! Mifi!' # TODO now always return hi
  end
end

