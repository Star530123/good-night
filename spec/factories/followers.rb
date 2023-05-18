# == Schema Information
#
# Table name: followers
#
#  id                :bigint           not null, primary key
#  user_id           :bigint           not null
#  following_user_id :bigint           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
FactoryBot.define do
  factory :follower do
  end
end
