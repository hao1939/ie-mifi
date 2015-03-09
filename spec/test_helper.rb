ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'rack/test'
require File.expand_path('../../myapp.rb',  __FILE__)

class MyAppTest < MiniTest::Test
  include Rack::Test::Methods

  def app
    MyApp
  end
end
