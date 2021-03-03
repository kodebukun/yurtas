class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string :title, null:false
      t.text :content, null:false
      t.integer :user_id
      t.integer :work_id
      t.integer :department_id
      t.boolean :meeting, null:false, default: false

      t.timestamps
    end
  end
end
