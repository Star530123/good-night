require 'rails_helper'

describe UsersController, type: :request do
  let!(:user) { create(:user, name: 'Simon') }
  let(:current_time) { Time.parse('2023-05-18 10:00:00+00:00') }

  before { travel_to(current_time) }
  after { travel_back }

  describe '#clock_in' do
    let(:params) { { user_id: user.id } }
    let(:post_api) { post '/sleep/clock_in', params: params }
    shared_examples 'post api success' do
      it 'success' do
        post_api
        expect(response.status).to eq(200)
        result = JSON.parse(response.body)
        expect(Time.parse(result['clock_in'])).to eq(current_time)
      end
    end

    include_examples 'post api success'

    context 'has one complete sleep record' do
      let!(:sleep_record) do 
        create(:sleep_record, user: user, clock_in: 2.hours.ago, clock_out: 1.hours.ago, sleep_length_seconds: 3600)
      end

      include_examples 'post api success'
    end

    context 'has not clocked out the past record' do
      let!(:sleep_record) { create(:sleep_record, user: user, clock_in: 2.hours.ago)}

      it 'fail' do
        post_api
        expect(response.status).to eq(500)
      end
    end
  end

  describe '#clock_out' do
    let(:params) { { user_id: user.id } }
    let(:post_api) { post '/sleep/clock_out', params: params }
    let!(:sleep_record) { create(:sleep_record, user: user, clock_in: 2.hours.ago) }

    it 'success' do
      post_api
      expect(response.status).to eq(200)
      result = JSON.parse(response.body)
      expect(Time.parse(result['clock_out'])).to eq(current_time)
      expect(result['sleep_length']).to eq('02:00:00')
    end

    context 'does not have any sleep_record' do
      let!(:sleep_record) { }

      it 'fail' do
        post_api
        expect(response.status).to eq(500)
      end
    end

    context 'has not clocked in' do
      let!(:sleep_record) do 
        create(:sleep_record, user: user, clock_in: 2.hours.ago, clock_out: 1.hours.ago)
      end

      it 'fails' do
        post_api
        expect(response.status).to eq(500)
      end
    end
  end

  describe '#clocked_in_times' do
    let(:params) { { user_id: user.id } }
    let(:get_api) { get '/sleep/clocked_in_times', params: params }

    context 'no sleep_records' do
      it 'success' do
        get_api
        expect(response.status).to eq(200)
        result = JSON.parse(response.body)
        sleep_records = result['sleep_records']
        expect(result['user_id']).to eq(user.id)
        expect(sleep_records).to eq([])
      end
    end

    context 'has two sleep_records' do
      it 'success' do
        create(:sleep_record, user: user, clock_in: 2.hours.ago, clock_out: 1.hours.ago)
        create(:sleep_record, user: user, clock_in: 1.hours.ago, clock_out: current_time)

        get_api
        expect(response.status).to eq(200)
        result = JSON.parse(response.body)
        sleep_records = result['sleep_records']
        expect(result['user_id']).to eq(user.id)
        expect(sleep_records.size).to eq(2)
        expect(Time.parse(sleep_records[0]['clock_in'])).to eq(1.hours.ago)
        expect(Time.parse(sleep_records[0]['clock_out'])).to eq(current_time)
        expect(Time.parse(sleep_records[1]['clock_in'])).to eq(2.hours.ago)
        expect(Time.parse(sleep_records[1]['clock_out'])).to eq(1.hours.ago)
      end
    end
  end

  describe '#following_user_records' do
    let(:params) { { user_id: user.id } }
    let(:get_api) { get '/sleep/following_user_records', params: params }

    context 'has no friends' do
      it 'success' do
        get_api
  
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)['sleep_records']).to eq([])
      end
    end

    context 'has friend(s)' do
      let(:user_1) { create(:user, name: 'YuXing') }
      let!(:follower_1) { create(:follower, user: user, following_user: user_1) }
      let!(:user_1_sleep_record) { create(:sleep_record, user: user_1, clock_in: 2.hours.ago, clock_out: 1.hours.ago) }
  
      context 'has one friend' do
        it 'success' do
          get_api
    
          expect(response.status).to eq(200)
          result = JSON.parse(response.body)['sleep_records']
          expect(result.size).to eq(1)
          sleep_record = result[0]
          expect(sleep_record['user_id']).to eq(user_1.id)
          expect(sleep_record['name']).to eq('YuXing')
          expect(Time.parse(sleep_record['clock_in'])).to eq(2.hours.ago)
          expect(Time.parse(sleep_record['clock_out'])).to eq(1.hours.ago)
          expect(sleep_record['sleep_length']).to eq('01:00:00')
        end
      end
  
      context 'has two friends' do
        let(:user_2) { create(:user, name: 'Star') }
        let!(:follower_2) { create(:follower, user: user, following_user: user_2) }
        let!(:user_2_sleep_record_1) { create(:sleep_record, user: user_2, clock_in: 3.hours.ago, clock_out: 2.5.hours.ago) }
        let!(:user_2_sleep_record_2) { create(:sleep_record, user: user_2, clock_in: 2.hours.ago, clock_out: current_time) }
  
        it 'success (order by sleep length desc)' do
          get_api
    
          expect(response.status).to eq(200)
          result = JSON.parse(response.body)['sleep_records']
          expect(result.size).to eq(3)
  
          first_sleep_records = result[0]
          expect(first_sleep_records['user_id']).to eq(user_2.id)
          expect(first_sleep_records['name']).to eq('Star')
          expect(Time.parse(first_sleep_records['clock_in'])).to eq(2.hours.ago)
          expect(Time.parse(first_sleep_records['clock_out'])).to eq(current_time)
          expect(first_sleep_records['sleep_length']).to eq('02:00:00')

          second_sleep_records = result[1]
          expect(second_sleep_records['user_id']).to eq(user_1.id)
          expect(second_sleep_records['name']).to eq('YuXing')
          expect(Time.parse(second_sleep_records['clock_in'])).to eq(2.hours.ago)
          expect(Time.parse(second_sleep_records['clock_out'])).to eq(1.hours.ago)
          expect(second_sleep_records['sleep_length']).to eq('01:00:00')
  
          third_sleep_records = result[2]
          expect(third_sleep_records['user_id']).to eq(user_2.id)
          expect(third_sleep_records['name']).to eq('Star')
          expect(Time.parse(third_sleep_records['clock_in'])).to eq(3.hours.ago)
          expect(Time.parse(third_sleep_records['clock_out'])).to eq(2.5.hours.ago)
          expect(third_sleep_records['sleep_length']).to eq('00:30:00')
        end
      end
    end
  end
end