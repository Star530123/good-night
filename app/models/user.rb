# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  name       :string(40)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class User < ApplicationRecord
  has_many :sleep_records
  has_many :followers, class_name: 'Follower', foreign_key: 'following_user_id', dependent: :destroy
  has_many :following_users, class_name: 'Follower', foreign_key: 'follower_id', dependent: :destroy
end
