require 'sinatra/activerecord'
require 'mifi/card_reader'
require File.expand_path('../../../app/models/sim_card.rb',  __FILE__)

namespace :mifi do
  desc "init sim_cards, read data files and mark the card_addr of the sim_cards"
  task :sim_cards do
    error_list = []
    SimCard.update_all(:ready => false)
    Mifi::CardReader.use_usb_reader # TODO
    # Mifi::CardReader.use_net_reader
    Mifi::CardReader.readers.each do |reader_name|
      sim_cards = Mifi::CardReader.read(reader_name)
      sim_cards.each do |sim_card|
        if sim_card[:errors]
          error_list.push(sim_card)
          next
        end
        s = SimCard.find_or_create_by(imsi: sim_card[:imsi]) do |s|
          # Those assignment only happens the first time!
          s.mcc = sim_card[:mcc]
          s.mnc = sim_card[:mnc]
          s.data_files = sim_card[:data_files]
          s.auth_dir_cmd = sim_card[:auth_dir_cmd]
          s.status = 'free'
        end
        s.card_addr = sim_card[:card_addr]
        s.ready = true
        error_list.push(sim_card) unless s.save
      end
    end
    puts "Errors: #{error_list}"
  end
end
