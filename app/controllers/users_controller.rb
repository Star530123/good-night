class UsersController < ApplicationController
  def follow
    follower = User.find_by!(id: follow_params[:follower_id])
    followed_user = User.find_by!(id: follow_params[:following_user_id])
    Follower.find_or_create_by!(user: follower, following_user: followed_user)
    render json: {
      follower: {
        id: follower.id,
        following_user_id: followed_user.id
      }
    }, status: :ok
  end

  def unfollow
    destroy_id = Follower.find_by(
      follower_id: unfollow_params[:follower_id], 
      following_user_id: unfollow_params[:unfollow_user_id]
    )&.id
    Follower.destroy(destroy_id) if destroy_id
  end

  private

  def follow_params
    params.permit(:follower_id, :following_user_id)
  end

  def unfollow_params
    params.permit(:follower_id, :unfollow_user_id)
  end
end
