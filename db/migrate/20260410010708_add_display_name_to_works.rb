class AddDisplayNameToWorks < ActiveRecord::Migration[5.2]
  def change
    add_column :works, :display_name, :string
  end
end
