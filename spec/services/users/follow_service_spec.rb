require 'rails_helper'

describe 'Users::FollowService' do
  let(:user) { create(:user) }
  let(:following_user) { create(:user) }

  it 'success' do
    Users::FollowService.execute(user: user, following_user_id: following_user.id)
    expect(Follower.all.size).to eq(1)
    follower = Follower.first
    expect(follower.user_id).to eq(user.id)
    expect(follower.following_user_id).to eq(following_user.id)
  end

  context 'non-exist following_user_id' do
    let(:following_user) {}

    it 'fail' do
      expect {  Users::FollowService.execute(user: user, following_user_id: user.id + 1) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end