class CreateAccessPoints < ActiveRecord::Migration[5.2]
  def change
    create_table :access_points do |t|
      t.string :ssid, null:false
      t.integer :inspection_room_id, null:false
      t.string :password, null:false

      t.timestamps
    end
  end
end
