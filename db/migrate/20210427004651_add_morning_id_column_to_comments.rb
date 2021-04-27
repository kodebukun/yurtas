class AddMorningIdColumnToComments < ActiveRecord::Migration[5.2]
  def change
    add_column :comments, :morning_id, :integer
    change_column_null :comments, :post_id, true
  end
end
