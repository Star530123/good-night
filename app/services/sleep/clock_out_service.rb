class Sleep::ClockOutService < BaseService

  def initialize(user:)
    super()
    @user = user
  end

  def execute
    sleep_record = @user.sleep_records.last
    raise "You haven't clocked in!" if sleep_record.nil? || sleep_record.clock_out.present?

    sleep_record.update!(clock_out: Time.now)
    sleep_record
  end
end