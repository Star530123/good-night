class Sleep::ClockInService < BaseService
  attr_reader :user
  
  def initialize(user:)
    super()
    @user = user
  end

  def execute
    sleep_record = user.sleep_records.last
    raise "You haven't clocked out!" if sleep_record && sleep_record.clock_out.nil?

    SleepRecord.create(user: user, clock_in: Time.now)
  end
end