class SleepController < ApplicationController
  include SleepSharedMethods

  def clock_in
    new_sleep_record = Sleep::ClockInService.execute(user: login_user)
    render json: { clock_in: new_sleep_record.clock_in }
  end

  def clock_out
    render json: format_sleep_record(Sleep::ClockOutService.execute(user: login_user))
  end

  def clocked_in_times
    sleep_records = login_user.sleep_records.order(created_at: :desc).map(&method(:format_sleep_record))
    render json: {
      user_id: login_user.id,
      sleep_records: sleep_records
    }
  end

  def following_user_records
    render json: { sleep_records: Sleep::FollowingUserRecordsService.execute(user: login_user) }
  end
end
