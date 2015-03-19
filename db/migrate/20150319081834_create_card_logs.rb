class CreateCardLogs < ActiveRecord::Migration
  def change
    create_table :card_logs  do |t|
      t.belongs_to :user, limit: 8, index: true
      t.belongs_to :card_binding, limit: 8, index: true
      t.string :text
      t.string :client_time
      t.timestamps null: false
    end
  end
end
