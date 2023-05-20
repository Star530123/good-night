class SleepController < ApplicationController
  def clock_in
    new_sleep_record = Sleep::ClockInService.execute(user: login_user)
    render json: { clock_in: new_sleep_record.clock_in }
  end

  def clock_out
    sleep_record = Sleep::ClockOutService.execute(user: login_user)
    render json: {
      clock_in: sleep_record.clock_in,
      clock_out: sleep_record.clock_out,
      sleep_length: Utils::Time.elapsed_time_format(sleep_record.sleep_length_seconds)
    }
  end

  def clocked_in_times
    sleep_records = login_user.sleep_records.order(created_at: :desc)
      .map do |sleep_record|
        {
          clock_in: sleep_record.clock_in,
          clock_out: sleep_record.clock_out
        }
    end
    render json: {
      user_id: login_user.id,
      sleep_records: sleep_records 
    }, status: :ok
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
    sleep_records = user.sleep_records.map do |sleep_record|
      {
        clock_in: sleep_record.clock_in,
        clock_out: sleep_record.clock_out,
        sleep_length: Utils::Time.elapsed_time_format(sleep_record.sleep_length_seconds)
      }
    end

    { id: user.id, name: user.name, sleep_records: sleep_records }
  end
end
