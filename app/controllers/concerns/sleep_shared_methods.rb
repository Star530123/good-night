module SleepSharedMethods
  extend ActiveSupport::Concern

  def format_sleep_record(record)
    {
      clock_in: record.clock_in,
      clock_out: record.clock_out,
      sleep_length: Utils::Time.elapsed_time_format(record.sleep_length_seconds)
    }
  end

  def format_sleep_record_with_user(record)
    {
      user_id: record.user.id,
      name: record.user.name,
      **format_sleep_record(record)
    }
  end
end