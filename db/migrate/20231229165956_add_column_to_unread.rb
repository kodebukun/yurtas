class AddColumnToUnread < ActiveRecord::Migration[5.2]
  def change
    add_column :unreads, :incident_id, :integer
    add_column :incidents, :user_id, :integer
  end
end
