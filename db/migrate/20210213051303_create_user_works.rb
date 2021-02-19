class CreateUserWorks < ActiveRecord::Migration[5.2]
  def change
    create_table :user_works do |t|
      t.references :user, foreign_key: true
      t.references :work, foreign_key: true

      t.timestamps
    end
  end
end
