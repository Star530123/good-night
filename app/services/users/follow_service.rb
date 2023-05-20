class Users::FollowService < BaseService

  def initialize(user:, following_user_id:)
    super()
    @user = user
    @following_user = User.find_by!(id: following_user_id)
  end

  def execute
    Follower.find_or_create_by!(user: @user, following_user: @following_user)
  end
end