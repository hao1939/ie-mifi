require 'sinatra/base'
require 'sinatra/activerecord'
require 'mifi_crypt'

require File.expand_path('../app/helpers/package_helpers.rb',  __FILE__)
require File.expand_path('../app/models/sim_card.rb', __FILE__)
require File.expand_path('../app/models/mifi_request.rb', __FILE__)

class MyApp < Sinatra::Base
  register Sinatra::ActiveRecordExtension

  configure :development, :test do
    require 'pry'
  end

  helpers MyAppHelpers

  include MifiCrypt

  get '/' do
    "Hello ieMiFi!"
  end

  before do
    @data, @raw = parse_body(request.body)
  end

  before '/3g' do
    @mifi_request = MifiRequest.new(@data, @raw)
    halt(400, 'sign error!') unless @mifi_request.valid?
    @pkey = @mifi_request.pkey
  end

  post '/3g' do
    sim_card = SimCard.new # TODO
    #binding.pry
    '1' + pk_encrypt(@pkey, sim_card.g3)
  end

  post '/auth' do
    binding.pry
  end
end

