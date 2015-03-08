require 'sinatra/base'
require 'sinatra/activerecord'

require File.expand_path('../app/helpers/package_helpers.rb',  __FILE__)
require File.expand_path('../app/models/vsimcard.rb',  __FILE__)

class MyApp < Sinatra::Base
  register Sinatra::ActiveRecordExtension

  configure :development, :test do
    require 'pry'
  end

  helpers MyAppHelpers

  get '/' do
    "Hello ieMiFi!"
  end

  before :method => :post do
    @package = parse_body(request.body)
  end

  post '/3g' do
    binding.pry
    key = @package[11]
    pk_encrypt(key, Vsimcard.to_package)
  end

  post '/auth' do
    binding.pry
  end

end

