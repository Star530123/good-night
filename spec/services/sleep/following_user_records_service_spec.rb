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
        sleep_record = records[0]
        expect(sleep_record[:user_id]).to eq(user_1.id)
        expect(sleep_record[:name]).to eq('YuXing')
        expect(sleep_record[:clock_in]).to eq(2.hours.ago)
        expect(sleep_record[:clock_out]).to eq(1.hours.ago)
        expect(sleep_record[:sleep_length]).to eq('01:00:00')
      end
    end

    context 'has two friends' do
      let(:user_2) { create(:user, name: 'Star') }
      let!(:follower_2) { create(:follower, user: user, following_user: user_2) }
      let!(:user_2_sleep_record_1) { create(:sleep_record, user: user_2, clock_in: 3.hours.ago, clock_out: 2.5.hours.ago) }
      let!(:user_2_sleep_record_2) { create(:sleep_record, user: user_2, clock_in: 7.days.ago, clock_out: 7.days.ago + 2.hours) }

      it 'success and return three sleep records (order by sleep length desc)' do
        records = Sleep::FollowingUserRecordsService.execute(user: user)
        expect(records.size).to eq(3)

        first_sleep_records = records[0]
        expect(first_sleep_records[:user_id]).to eq(user_2.id)
        expect(first_sleep_records[:name]).to eq('Star')
        expect(first_sleep_records[:clock_in]).to eq(7.days.ago)
        expect(first_sleep_records[:clock_out]).to eq(7.days.ago + 2.hours)
        expect(first_sleep_records[:sleep_length]).to eq('02:00:00')

        second_sleep_records = records[1]
        expect(second_sleep_records[:user_id]).to eq(user_1.id)
        expect(second_sleep_records[:name]).to eq('YuXing')
        expect(second_sleep_records[:clock_in]).to eq(2.hours.ago)
        expect(second_sleep_records[:clock_out]).to eq(1.hours.ago)
        expect(second_sleep_records[:sleep_length]).to eq('01:00:00')

        third_sleep_records = records[2]
        expect(third_sleep_records[:user_id]).to eq(user_2.id)
        expect(third_sleep_records[:name]).to eq('Star')
        expect(third_sleep_records[:clock_in]).to eq(3.hours.ago)
        expect(third_sleep_records[:clock_out]).to eq(2.5.hours.ago)
        expect(third_sleep_records[:sleep_length]).to eq('00:30:00')
      end

      context "the second friend's records are 7 days ago" do
        let(:record_day) { 7.days.ago.at_beginning_of_day }
        let!(:user_2_sleep_record_1) { create(:sleep_record, user: user_2, clock_in:  record_time(3.hours), clock_out: record_time(2.5.hours)) }
        let!(:user_2_sleep_record_2) { create(:sleep_record, user: user_2, clock_in:  record_time(2.hours), clock_out: record_day) }

        def record_time(time)
          record_day - time 
        end

        it "success and return just the first friend's sleep record" do
          records = Sleep::FollowingUserRecordsService.execute(user: user)
          expect(records.size).to eq(1)

          sleep_record = records[0]
          expect(sleep_record[:user_id]).to eq(user_1.id)
          expect(sleep_record[:name]).to eq('YuXing')
          expect(sleep_record[:clock_in]).to eq(2.hours.ago)
          expect(sleep_record[:clock_out]).to eq(1.hours.ago)
          expect(sleep_record[:sleep_length]).to eq('01:00:00')
        end
      end
    end
  end
end