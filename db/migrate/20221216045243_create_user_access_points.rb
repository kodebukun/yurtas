class CreateUserAccessPoints < ActiveRecord::Migration[5.2]
  def change
    create_table :user_access_points do |t|
      t.references :user, foreign_key: true
      t.references :access_point, foreign_key: true

      t.timestamps
    end
  end
end
