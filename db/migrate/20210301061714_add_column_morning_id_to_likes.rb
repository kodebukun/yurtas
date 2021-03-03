class AddColumnMorningIdToLikes < ActiveRecord::Migration[5.2]
  def change
    add_column :likes, :morning_id, :integer
  end
end
