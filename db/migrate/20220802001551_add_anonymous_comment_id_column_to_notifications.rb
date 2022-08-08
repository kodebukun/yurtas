class AddAnonymousCommentIdColumnToNotifications < ActiveRecord::Migration[5.2]
  def change
    add_column :notifications, :anonymous_post_id, :integer
    add_column :notifications, :anonymous_comment_id, :integer
    add_index :notifications, :anonymous_post_id
    add_index :notifications, :anonymous_comment_id
  end
end
