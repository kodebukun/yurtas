class CreateInspectionRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :inspection_rooms do |t|
      t.string :name, null:false
      t.integer :department_id, null:false

      t.timestamps
    end
  end
end
