require 'rails_helper'

describe 'Sleep::ClockInService' do
  let(:user) { create(:user) }
  let(:current_time) { Time.parse('2023-05-18 10:00:00+00:00') }

  before { travel_to(current_time) }
  after { travel_back }

  shared_examples 'execute service success' do
    it 'success' do
      record = Sleep::ClockInService.execute(user: user)
      expect(record.clock_in).to eq(current_time)
    end
  end

  include_examples 'execute service success'

  context 'has one complete sleep record' do
    let!(:sleep_record) do 
      create(:sleep_record, user: user, clock_in: 2.hours.ago, clock_out: 1.hours.ago, sleep_length_seconds: 3600)
    end

    include_examples 'execute service success'
  end

  context 'has not clocked out the past record' do
    let!(:sleep_record) { create(:sleep_record, user: user, clock_in: 2.hours.ago) }

    it 'fail' do
      expect { Sleep::ClockInService.execute(user: user) }.to raise_error(RuntimeError)
    end
  end
end