class AddMorningIdColumnToNotifications < ActiveRecord::Migration[5.2]
  def change
    add_column :notifications, :morning_id, :integer
    add_index :notifications, :morning_id
  end
end
