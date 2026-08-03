class CreatePushSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :push_subscriptions do |t|
      t.references :user, null: false, foreign_key: true, index: true
      t.string :endpoint, null: false
      t.string :p256dh, null: false
      t.string :auth, null: false
      t.timestamps
    end
    add_index :push_subscriptions, :endpoint, unique: true
  end
end
