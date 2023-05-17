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
end