class CreateAnonymousComments < ActiveRecord::Migration[5.2]
  def change
    create_table :anonymous_comments do |t|
      t.text :content, null:false
      t.integer :user_id, null:false
      t.integer :anonymous_post_id, null:false
      t.boolean :breach, default: false, null: false
      t.string :nickname, null:false
      t.string :position, default: 'neutral', null: false

      t.timestamps
    end
  end
end
