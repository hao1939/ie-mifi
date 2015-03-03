require 'sinatra/base'
require "sinatra/activerecord"

class MyApp < Sinatra::Base
  register Sinatra::ActiveRecordExtension

  get '/' do
    "Hello ieMiFi!"
  end
 
  post '/' do
    puts request.body.read
  end
end

