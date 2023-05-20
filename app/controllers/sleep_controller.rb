class SleepController < ApplicationController
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
    start_time = 7.days.ago.at_beginning_of_day
    end_time = Time.now
    following_users = login_user.following_users
      .includes(:sleep_records)
      .sort_by { |user| user.sleep_records.where(created_at: start_time...end_time).sum(:sleep_length_seconds) }
      .reverse

    render json: { data: following_users.map(&method(:following_user_records_response)) }, status: :ok
  end

  private

  def following_user_records_response(user)
    {
      id: user.id,
      name: user.name,
      sleep_records: user.sleep_records.map(&method(:format_sleep_record))
    }
  end

  def format_sleep_record(record)
    {
      clock_in: record.clock_in,
      clock_out: record.clock_out,
      sleep_length: Utils::Time.elapsed_time_format(record.sleep_length_seconds)
    }
  end
end
