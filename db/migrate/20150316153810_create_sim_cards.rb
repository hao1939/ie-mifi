class CreateSimCards < ActiveRecord::Migration
  def change
    create_table :sim_cards do |t|
      t.string :status # 'marked': selected for binding, 'used': alreding binded, 'free': avaliable
      t.boolean :enabled, default: false # whether enabled for data network
      t.binary :imsi, limit: 9
      t.binary :mcc, limit: 2
      t.binary :mnc, limit: 1
      t.binary :data_files # files with_out 2ff1
      t.timestamps null: false
    end
  end
end
