class CreateDiaries < ActiveRecord::Migration[5.2]
  def change
    create_table :diaries do |t|
      t.string :title, null: false
      t.text :content, null: false
      t.integer :user_id
      t.integer :partner_id

      t.timestamps
    end
  end
end
