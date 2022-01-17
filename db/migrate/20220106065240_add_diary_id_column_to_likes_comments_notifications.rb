class AddDiaryIdColumnToLikesCommentsNotifications < ActiveRecord::Migration[5.2]
  def change
    add_column :likes, :diary_id, :integer
    add_column :comments, :diary_id, :integer
    add_column :notifications, :diary_id, :integer
  end
end
