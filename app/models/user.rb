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

  has_many :follow_data, class_name: 'Follower', dependent: :destroy
  has_many :following_users, through: :follow_data
end
