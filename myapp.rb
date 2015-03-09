require 'sinatra/base'
require 'sinatra/activerecord'
require 'mifi_crypt'

require File.expand_path('../app/helpers/package_helpers.rb',  __FILE__)
require File.expand_path('../app/models/sim_card.rb', __FILE__)

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

  before :method => :post do
    @package = parse_body(request.body)
    @pkey = @package[11]
  end

  post '/3g' do
    sim_card = SimCard.new # TODO
    binding.pry
    '1' + pk_encrypt(@pkey, sim_card.g3)
  end

  post '/auth' do
    binding.pry
  end
end

