class CreateMornings < ActiveRecord::Migration[5.2]
  def change
    create_table :mornings do |t|
      t.string :title, null:false
      t.text :content, null:false
      t.integer :user_id, null:false
      t.string :absentee

      t.timestamps
    end
  end
end
