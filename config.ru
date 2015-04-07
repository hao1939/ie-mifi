require File.expand_path('../myapp.rb',  __FILE__)

Mifi::CardReader.use_net_reader

run MyApp
