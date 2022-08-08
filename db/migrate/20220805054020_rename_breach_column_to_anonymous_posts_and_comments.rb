class RenameBreachColumnToAnonymousPostsAndComments < ActiveRecord::Migration[5.2]
  def up
    rename_column :anonymous_posts, :breach, :safety
    rename_column :anonymous_comments, :breach, :safety
  end

  def down
    rename_column :anonymous_posts, :safety, :breach
    rename_column :anonymous_comments, :safety, :breach
  end
end
