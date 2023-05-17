# == Schema Information
#
# Table name: followers
#
#  id                :bigint           not null, primary key
#  follower_id       :bigint           not null
#  following_user_id :bigint           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class Follower < ApplicationRecord
  belongs_to :user, class_name: 'User', foreign_key: 'follower_id'
  belongs_to :following_user, class_name: 'User', foreign_key: 'following_user_id'
end
