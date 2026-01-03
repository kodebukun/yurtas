class AddDepartmentIdColumnImages < ActiveRecord::Migration[5.2]
  def change
    add_column :images, :department_id, :bigint
  end
end
