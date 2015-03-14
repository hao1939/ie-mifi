class CreateFlowLogs < ActiveRecord::Migration
  def change
    create_table :flow_logs do |t|
      t.references :user, limit: 8, index: true
      t.integer :count, limit: 8
    end
  end
end
