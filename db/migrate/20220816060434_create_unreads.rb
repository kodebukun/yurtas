class CreateUnreads < ActiveRecord::Migration[5.2]
  def change
    create_table :unreads do |t|
      t.integer :user_id, null:false
      t.integer :post_id
      t.integer :anonymous_post_id
      t.integer :department_id
      t.integer :work_id

      t.timestamps
    end
  end
end
