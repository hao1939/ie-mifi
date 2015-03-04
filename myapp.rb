require 'sinatra/base'
require 'sinatra/activerecord'

require File.expand_path('../app/helpers/package_helpers.rb',  __FILE__)

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
    'everything fine.'
  end

end

