class Users::UnfollowService < BaseService

  def initialize(user:, unfollow_user_id:)
    super()
    @user = user
    @unfollow_user_id = unfollow_user_id
  end

  def execute
    destroy_id = Follower.find_by(
      user: @user,
      following_user_id: @unfollow_user_id
    )&.id
    Follower.destroy(destroy_id) if destroy_id
  end
end