class Sleep::FollowingUserRecordsService < BaseService
  include SleepSharedMethods

  def initialize(user:)
    super()
    @user = user
  end

  def execute
    start_time = 7.days.ago.at_beginning_of_day
    SleepRecord.complete
               .where(user: @user.following_users, created_at: start_time..)
               .sort_by(&:sleep_length_seconds)
               .reverse
               .map(&method(:format_sleep_record_with_user))
  end
end