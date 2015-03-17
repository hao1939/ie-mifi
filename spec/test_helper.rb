ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'rack/test'

require 'database_cleaner'
DatabaseCleaner[:active_record].strategy = :transaction

require File.expand_path('../../myapp.rb',  __FILE__)

class MyAppTest < MiniTest::Test
  include Rack::Test::Methods

  def app
    MyApp
  end
end

class MiniTest::Spec
  include Rack::Test::Methods

  before :each do
    DatabaseCleaner.start
  end

  after :each do
    DatabaseCleaner.clean
  end
end
