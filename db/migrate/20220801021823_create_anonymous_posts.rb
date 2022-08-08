class CreateAnonymousPosts < ActiveRecord::Migration[5.2]
  def change
    create_table :anonymous_posts do |t|
      t.string :title, null:false
      t.text :content, null:false
      t.integer :user_id
      t.boolean :breach, default: false, null: false
      t.boolean :resolved, default: false, null: false

      t.timestamps
    end
  end
end
