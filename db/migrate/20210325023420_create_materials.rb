class CreateMaterials < ActiveRecord::Migration[5.2]
  def change
    create_table :materials do |t|
      t.string :name, null: false
      t.integer :manufacturer_id
      t.string :place
      t.string :use
      t.date :install_date
      t.date :update_date

      t.timestamps
    end
  end
end
