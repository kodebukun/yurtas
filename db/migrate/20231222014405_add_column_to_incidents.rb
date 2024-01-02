class AddColumnToIncidents < ActiveRecord::Migration[5.2]
  def change
    add_column :incidents, :title, :string
    add_column :incidents, :content, :text
  end
end
