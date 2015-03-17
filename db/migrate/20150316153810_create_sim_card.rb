class CreateSimCard < ActiveRecord::Migration
  def change
    create_table :sim_cards do |t|
      t.timestamps null: false
    end
  end
end
