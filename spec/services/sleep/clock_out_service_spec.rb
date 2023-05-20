require 'rails_helper'

describe 'Sleep::ClockOutService' do
  let(:user) { create(:user) }
  let(:current_time) { Time.parse('2023-05-18 10:00:00+00:00') }

  before { travel_to(current_time) }
  after { travel_back }

  let!(:sleep_record) { create(:sleep_record, user: user, clock_in: 2.hours.ago) }

  it 'success' do
    record = Sleep::ClockOutService.execute(user: user)
    expect(record.clock_in).to eq(2.hours.ago)
    expect(record.clock_out).to eq(current_time)
  end

  context 'does not have any sleep_record' do
    let!(:sleep_record) {}

    it 'fail' do
      expect { Sleep::ClockOutService.execute(user: user) }.to raise_error(RuntimeError)
    end
  end

  context 'has not clocked in' do
    let!(:sleep_record) do
      create(:sleep_record, user: user, clock_in: 2.hours.ago, clock_out: 1.hours.ago)
    end

    it 'fails' do
      expect { Sleep::ClockOutService.execute(user: user) }.to raise_error(RuntimeError)
    end
  end
end