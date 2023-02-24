class CreateSecuritySofts < ActiveRecord::Migration[5.2]
  def change
    create_table :security_softs do |t|
      t.string :name, null:false

      t.timestamps
    end
  end
end
