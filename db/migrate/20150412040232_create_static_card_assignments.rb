class CreateStaticCardAssignments < ActiveRecord::Migration
  def change
    create_table :static_card_assignments  do |t|
      t.integer :user_id, limit: 8, null: false, index: true
      t.integer :sim_card_id, limit: 8, null: false
      t.datetime :active_from, null: false
      t.datetime :expire_on, null: false
      t.timestamps null: false
    end
  end
end
