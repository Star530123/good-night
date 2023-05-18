require 'rails_helper'

describe UsersController, type: :request do
  before { create(:user, name: 'Simon')}

  describe '#index' do
    it 'success' do
      get '/users'

      expect(response.status).to eq(200)
    end
  end

  describe '#create' do
    let(:params) { { name: 'YuXing' } }
    let(:post_api) { post '/users', params: params }

    it 'success' do
      post_api

      expect(response.status).to eq(200)
    end

    context 'given incorrect parameter name: username' do
      let(:params) { { username: 'YuXing' } }

      it 'fail' do
        post_api

        expect(response.status).to eq(500)
      end
    end
  end

  describe '#follow' do
    let(:user) { create(:user) }
    let(:following_user) { create(:user) }
    let(:params) { { user_id: user&.id, following_user_id: following_user&.id } }
    let(:post_api) { post '/users/follow', params: params }

    it 'success' do
      post_api

      expect(response.status).to eq(200)
      expect(Follower.all.size).to eq(1)
      follower = Follower.first
      expect(follower.user_id).to eq(user.id)
      expect(follower.following_user_id).to eq(following_user.id)
    end

    context 'non-exist user_id' do
      let(:params) { { user_id: user&.id + 10, following_user_id: following_user&.id } }

      it 'fail' do
        post_api

        expect(response.status).to eq(500)
      end
    end

    context 'non-exist following_user_id' do
      let(:params) { { user_id: user&.id, following_user_id: following_user&.id + 10} }

      it 'fail' do
        post_api

        expect(response.status).to eq(500)
      end
    end
  end

  describe '#unfollow' do
    let(:user) { create(:user) }
    let(:following_user) { create(:user) }
    let!(:follower) { create(:follower, user: user, following_user: following_user)}
    let(:params) { { user_id: user&.id, unfollow_user_id: following_user&.id } }
    let(:post_api) { post '/users/unfollow', params: params }

    it 'success' do
      post_api

      expect(response.status).to eq(204)
      expect(Follower.all.empty?).to be_truthy
    end
  end
end