class CreateEvaluations < ActiveRecord::Migration[5.2]
  def change
    create_table :evaluations do |t|
      t.integer :user_id, null:false
      t.integer :anonymous_post_id
      t.boolean :agreement, null:false

      t.timestamps
    end
  end
end
