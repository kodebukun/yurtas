class AddFileTypeToImages < ActiveRecord::Migration[5.2]
  def change
    add_column :images, :file_type, :string
  end
end
