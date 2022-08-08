class ChangeDatatypeSafetyOfAnonymousPostAndComment < ActiveRecord::Migration[5.2]
  def up
    change_column :anonymous_posts, :safety, :string, null: false, default: "safe"
    change_column :anonymous_comments, :safety, :string, null: false, default: "safe"
  end
  def down
    remove_column :anonymous_posts, :safety
    remove_column :anonymous_comments, :safety
    add_column :anonymous_posts, :safety, :boolean, null: false, default: false
    add_column :anonymous_comments, :safety, :boolean, null: false, default: false
  end
end
