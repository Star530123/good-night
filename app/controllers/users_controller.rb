class UsersController < ApplicationController
  def index
    render json: User.all.select(:id, :name)
  end

  def create
    user = User.create!(name: create_user_params)
    render json: user.as_json(only: [:id, :name])
  end

  def follow
    following_user_id = follow_params[:following_user_id]
    Users::FollowService.execute(user: login_user, following_user_id: following_user_id)
    render json: {
      follower: {
        user_id: login_user.id,
        following_user_id: following_user_id
      }
    }
  end

  def unfollow
    Users::UnfollowService.execute(user: login_user, unfollow_user_id: unfollow_params[:unfollow_user_id])
  end

  private

  def create_user_params
    params.require(:name)
  end

  def follow_params
    params.permit(:following_user_id)
  end

  def unfollow_params
    params.permit(:unfollow_user_id)
  end
end
