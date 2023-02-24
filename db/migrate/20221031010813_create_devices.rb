class CreateDevices < ActiveRecord::Migration[5.2]
  def change
    create_table :devices do |t|
      t.string :name, null:false
      t.string :os, null:false
      t.integer :security_soft_id
      t.integer :user_id
      t.string :type, null:false
      t.string :owner

      t.timestamps
    end
  end
end
