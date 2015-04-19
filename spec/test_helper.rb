ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'rack/test'
require 'pry'
require 'sinatra/activerecord'
require 'database_cleaner'
DatabaseCleaner[:active_record].strategy = :transaction

require_relative '../lib/utils.rb'

class MiniTest::Spec
  include Rack::Test::Methods

  def app
    MyApp
  end

  before :each do
    DatabaseCleaner.start
  end

  after :each do
    DatabaseCleaner.clean
  end
end
