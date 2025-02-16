class AddFileNameToImages < ActiveRecord::Migration[5.2]
  def change
    add_column :images, :file_name, :string, null: false, default: "default_name"
  end
end
