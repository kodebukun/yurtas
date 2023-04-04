class AddColumnToAnonymousPost < ActiveRecord::Migration[5.2]
  def change
    add_column :anonymous_posts, :discuss, :boolean, default: false, null: false
  end
end
