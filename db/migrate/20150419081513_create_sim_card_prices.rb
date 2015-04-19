class CreateSimCardPrices < ActiveRecord::Migration
  def change
    create_table :sim_card_prices  do |t|
      t.binary :loc_mcc, limit: 3, null: false, index: true
      t.string :loc_country
      t.binary :card_mcc, limit: 3, null: false
      t.binary :card_mnc, limit: 2, null: false
      t.integer :price, null: false, default: 1
      t.boolean :local, null: false
      t.string :memo
    end
    add_index :sim_card_prices, [:loc_mcc, :card_mcc, :card_mnc], unique: true
  end
end
