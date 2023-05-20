require 'rails_helper'

describe 'Users::UnfollowService' do
  let(:user) { create(:user) }
  let(:following_user) { create(:user) }
  let!(:follower) { create(:follower, user: user, following_user: following_user)}

  it 'success' do
    expect(Follower.all.size).to eq(1)
    Users::UnfollowService.execute(user: user, unfollow_user_id: following_user.id)
    expect(Follower.all.empty?).to be_truthy
  end
end