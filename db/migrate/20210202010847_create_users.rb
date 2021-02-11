class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.integer :login_id, null: false, unique: true
      t.string :password_digest, null: false
      t.string :email, null: false, unique: true
      t.string :phone_no, unique: true
      t.string :image_name

      t.timestamps
    end
  end
end
