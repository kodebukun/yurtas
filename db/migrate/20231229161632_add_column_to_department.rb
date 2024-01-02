class AddColumnToDepartment < ActiveRecord::Migration[5.2]
  def change
    add_column :departments, :order, :integer
  end
end
