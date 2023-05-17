class RenameFollowersColumn < ActiveRecord::Migration[7.0]
  def change
    rename_column :followers, :follower_id, :user_id
  end
end
