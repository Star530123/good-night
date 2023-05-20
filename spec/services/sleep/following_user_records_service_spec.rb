require 'rails_helper'

describe 'Sleep::FollowingUserRecordsService' do
  let(:user) { create(:user) }
  let(:current_time) { Time.parse('2023-05-18 10:00:00+00:00') }

  before { travel_to(current_time) }
  after { travel_back }

  context 'has no friends' do
    it 'success' do
      records = Sleep::FollowingUserRecordsService.execute(user: user)
      expect(records).to eq([])
    end
  end

  context 'has friend(s)' do
    let(:user_1) { create(:user, name: 'YuXing') }
    let!(:follower_1) { create(:follower, user: user, following_user: user_1) }
    let!(:user_1_sleep_record) { create(:sleep_record, user: user_1, clock_in: 2.hours.ago, clock_out: 1.hours.ago) }

    context 'has one friend' do
      it 'success' do
        records = Sleep::FollowingUserRecordsService.execute(user: user)
        expect(records.size).to eq(1)
        expect(records[0][:name]).to eq('YuXing')
        sleep_record = records[0][:sleep_records][0]
        expect(sleep_record[:clock_in]).to eq(2.hours.ago)
        expect(sleep_record[:clock_out]).to eq(1.hours.ago)
        expect(sleep_record[:sleep_length]).to eq('01:00:00')
      end
    end

    context 'has two friends' do
      let(:user_2) { create(:user, name: 'Star') }
      let!(:follower_2) { create(:follower, user: user, following_user: user_2) }
      let!(:user_2_sleep_record_1) { create(:sleep_record, user: user_2, clock_in: 3.hours.ago, clock_out: 2.hours.ago) }
      let!(:user_2_sleep_record_2) { create(:sleep_record, user: user_2, clock_in: 1.hours.ago, clock_out: current_time) }

      it 'success (order by total sleep length desc)' do
        records = Sleep::FollowingUserRecordsService.execute(user: user)
        expect(records.size).to eq(2)

        first_sleep_records = records[0][:sleep_records]
        expect(records[0][:name]).to eq('Star')
        expect(first_sleep_records[0][:clock_in]).to eq(3.hours.ago)
        expect(first_sleep_records[0][:clock_out]).to eq(2.hours.ago)
        expect(first_sleep_records[0][:sleep_length]).to eq('01:00:00')
        expect(first_sleep_records[1][:clock_in]).to eq(1.hours.ago)
        expect(first_sleep_records[1][:clock_out]).to eq(current_time)
        expect(first_sleep_records[1][:sleep_length]).to eq('01:00:00')

        second_sleep_records = records[1][:sleep_records]
        expect(records[1][:name]).to eq('YuXing')
        expect(second_sleep_records[0][:clock_in]).to eq(2.hours.ago)
        expect(second_sleep_records[0][:clock_out]).to eq(1.hours.ago)
        expect(second_sleep_records[0][:sleep_length]).to eq('01:00:00')
      end
    end
  end
end