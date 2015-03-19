class CreateCardBindings < ActiveRecord::Migration
  def change
    create_table :card_bindings  do |t|
      t.belongs_to :user, limit: 8
      t.belongs_to :sim_card, limit: 8, index: true
      t.binary :mac_key
      t.boolean :active, null: false, default: true
      t.timestamps null: false
    end
    add_index :card_bindings, [:user_id, :active]
  end
end
