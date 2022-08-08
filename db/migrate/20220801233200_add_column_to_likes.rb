class AddColumnToLikes < ActiveRecord::Migration[5.2]
  def change
    add_column :likes, :anonymous_comment_id, :integer
  end
end
