module SleepSharedMethods
  extend ActiveSupport::Concern

  def following_user_records_response(user)
    {
      user_id: user.id,
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