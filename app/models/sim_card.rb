require File.expand_path('../sim_card_init.rb', __FILE__)

class SimCard < ActiveRecord::Base
  def self.free_cards
    SimCard.where(status: 'free')
  end

  def g3_data
    file_2ff1 = (enabled?) ? card_init_param.file_2ff1 : card_init_param.init_file_2ff1
    data_files + file_2ff1
  end

  def mark
    self.status = 'marked'
  end

  def set_enabled!
    return if enabled?
    self.enabled = true
    save!
  end

  def card_init_param
    @sim_card_init ||= SimCardInit.where(:mcc => mcc, :mnc => mnc).first
  end
end
