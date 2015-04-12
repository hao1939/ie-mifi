require 'sinatra/activerecord'
require 'mifi/card_reader'
require File.expand_path('../../../app/models/sim_card.rb',  __FILE__)

Mifi::CardReader.use_net_reader

namespace :mifi do
  desc "read sim_cards, read data files and mark the card_addr of the sim_cards"
  task :read_sim_cards do
    error_list = []
    SimCard.update_all(:ready => false)
    Mifi::CardReader.readers.each do |reader_name|
      sim_cards = Mifi::CardReader.read(reader_name)
      sim_cards.each do |sim_card|
        if sim_card[:errors]
          error_list.push(sim_card)
          next
        end
        s = SimCard.find_or_create_by(imsi: sim_card[:imsi][0..8]) do |s|
          # Those assignment only happens the first time!
          s.mcc = sim_card[:mcc]
          s.mnc = sim_card[:mnc]
          s.data_files = sim_card[:data_files]
          s.auth_dir_cmd = sim_card[:auth_dir_cmd]
          s.status = 'locked'
        end
        s.card_addr = sim_card[:card_addr]
        s.ready = true
        error_list.push(sim_card) unless s.save
      end
    end
    puts "Errors: #{error_list}"
  end

  desc "verify mcc/mnc of sim_cards"
  task :verify_mcc_mnc do
    missing_mcc_mnc = []
    SimCard.select(:mcc, :mnc).distinct.each do |s|
      if SimCardInit.where(:mcc => s.mcc, :mnc => s.mnc).empty?
        missing_mcc_mnc.push({:mcc => s.mcc, :mnc => s.mnc})
      end
    end
    puts "Missing MCC/MNC: #{missing_mcc_mnc}"
  end

  task :default => :init
end
