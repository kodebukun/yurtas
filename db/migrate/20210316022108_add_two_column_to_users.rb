class AddTwoColumnToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :day_shift, :boolean, null:false, default:false
    add_column :users, :call, :boolean, null:false, default:false
  end
end
