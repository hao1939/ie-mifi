class CreateSimCard < ActiveRecord::Migration
  def change
    create_table :sim_cards do |t|
      t.string :status # 'marked', 'used', 'free'
      t.binary :imsi, limit: 9
      t.binary :data_files
      t.timestamps null: false
    end
  end
end
