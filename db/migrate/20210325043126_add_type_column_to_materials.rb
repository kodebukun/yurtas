class AddTypeColumnToMaterials < ActiveRecord::Migration[5.2]
  def change
    add_column :materials, :material_type, :string
    add_column :materials, :department_id, :integer
  end
end
