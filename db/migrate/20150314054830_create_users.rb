class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, :id => false do |t|
      t.integer :id, limit: 8
      t.binary :mac_key
      t.binary :reserved_key
      t.binary :rfm_encrypt_key
      t.binary :rfm_mac_key
      t.string :rfm_count
      t.binary :pkey # public key
      t.timestamps null: false
    end
    add_index :users, :id, :unique => true
  end
end
