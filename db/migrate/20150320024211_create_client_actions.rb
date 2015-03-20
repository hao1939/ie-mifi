class CreateClientActions < ActiveRecord::Migration
  def change
    create_table :client_actions  do |t|
      t.belongs_to :user, limit: 8, index: true
      t.binary :cmd
      t.boolean :delivered, default: false
      t.timestamps null: false
    end
  end
end
