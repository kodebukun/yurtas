class AddWorkIdColumnToImages < ActiveRecord::Migration[5.2]
  def change
    add_column :images, :work_id, :bigint
  end
end
