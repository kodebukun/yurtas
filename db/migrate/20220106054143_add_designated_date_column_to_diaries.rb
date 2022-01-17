class AddDesignatedDateColumnToDiaries < ActiveRecord::Migration[5.2]
  def change
    add_column :diaries, :designated_date, :date, null: false
  end
end
