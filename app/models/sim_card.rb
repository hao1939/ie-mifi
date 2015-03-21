require File.expand_path('../sim_card_init.rb', __FILE__)

class SimCard < ActiveRecord::Base
  def self.free_cards
    SimCard.where(status: 'free')
  end

  def g3_data
    return data_files + file_2ff1 if enabled?
    data_files + SimCardInit.where(:mcc_mnc => mcc_mnc).first.file_2ff1
  end

  def mark
    self.status = 'marked'
  end

  def set_enabled!
    return if enabled?
    self.enabled = true
    save!
  end
end
