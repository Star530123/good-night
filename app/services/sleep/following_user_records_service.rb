class Sleep::FollowingUserRecordsService < BaseService
  include SleepSharedMethods

  def initialize(user:)
    super()
    @user = user
  end

  def execute
    start_time = 7.days.ago.at_beginning_of_day
    end_time = Time.now
    @user.following_users
      .includes(:sleep_records)
      .sort_by { |user| user.sleep_records.where(created_at: start_time...end_time).sum(:sleep_length_seconds) }
      .reverse
      .map(&method(:following_user_records_response))
  end
end