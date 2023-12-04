class CreateIncidents < ActiveRecord::Migration[5.2]
  def change
    create_table :incidents do |t|
      t.string :shift, null:false
      t.datetime :occurred_at, null: false
      t.integer :department_id, null:false
      t.string :place, null:false
      t.integer :years, null:false
      t.string :target, null:false
      t.string :happened, null:false
      t.text :response
      t.text :measure
      t.text :excuse

      t.timestamps
    end
  end
end
