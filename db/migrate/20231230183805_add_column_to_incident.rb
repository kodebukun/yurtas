class AddColumnToIncident < ActiveRecord::Migration[5.2]
  def change
    add_column :incidents, :checked, :boolean, default: false
  end
end
