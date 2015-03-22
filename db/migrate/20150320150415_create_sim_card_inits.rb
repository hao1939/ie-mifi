class CreateSimCardInits < ActiveRecord::Migration
  def change
    create_table :sim_card_inits  do |t|
      t.binary :mcc, limit: 2, index: true
      t.binary :mnc, limit: 1, index: true
      t.string :country
      t.string :network
      t.binary :file_2ff1
      t.binary :init_file_2ff1
      t.string :memo
    end
  end
end
