class CreateBreaches < ActiveRecord::Migration[5.2]
  def change
    create_table :breaches do |t|
      t.text :content, null:false
      t.integer :user_id, null:false
      t.integer :anonymous_post_id
      t.integer :anonymous_comment_id
      t.boolean :approval, default: false, null: false
      t.boolean :checked, default: false, null: false
      
      t.timestamps
    end
  end
end
