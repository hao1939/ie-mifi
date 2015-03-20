class CreateSimCardInits < ActiveRecord::Migration
  def change
    create_table :sim_card_inits  do |t|
      t.binary :mcc_mnc, index: true
      t.binary :file_2ff1
    end
  end
end
