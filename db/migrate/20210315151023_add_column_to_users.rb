class AddColumnToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :night_shift, :boolean, null:false, default:false
  end
end
