require_relative './sim_card_init.rb'
require_relative './sim_card_price.rb'
class SimCard < ActiveRecord::Base
  scope :free_cards, -> { where(status: 'free', ready: true) }
  scope :with_mcc_mnc, ->(mcc, mnc) { free_cards.where(mcc: mcc, mnc: mnc) }

  def g3_data
    file_2ff1 = (network_enabled?) ? card_init_param.file_2ff1 : card_init_param.init_file_2ff1
    data_files + file_2ff1
  end

  def mark!
    self.status = 'marked'
    save
  end

  def set_network_enabled!
    return if network_enabled?
    self.network_enabled = true
    save!
  end

  def card_init_param
    @sim_card_init ||= SimCardInit.where(:mcc => mcc, :mnc => mnc).first
  end

  def avaliable_for?(loc_mcc)
    sim_card_price = SimCardPrice.where(:loc_mcc => loc_mcc, :card_mcc => mcc, :card_mnc => mnc)
    return !sim_card_price.empty?
  end
end
