class CreateFollowers < ActiveRecord::Migration[7.0]
  def change
    create_table :followers do |t|
      t.bigint :follower_id, null: false
      t.bigint :following_user_id, null: false

      t.timestamps

      t.index [:follower_id, :following_user_id], unique: true
    end
  end
end
