class CreatePageViews < ActiveRecord::Migration[5.2]
  def change
    create_table :page_views do |t|
      t.references :user, foreign_key: true
      t.string :page, null: false
      t.timestamps
    end
    add_index :page_views, [:user_id, :page]
  end
end
