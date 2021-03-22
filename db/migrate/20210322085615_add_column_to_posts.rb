class AddColumnToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :rule, :boolean, null:false, default:false
  end
end
