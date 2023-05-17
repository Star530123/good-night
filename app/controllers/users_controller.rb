class UsersController < ApplicationController
  def index
    render json: User.all.select(:id, :name), status: :ok
  end

  def create
    user = User.create!(name: create_user_params[:name])
    render json: user.as_json(only: [:id, :name]), status: :ok
  end

  def follow
    user = User.find_by!(id: follow_params[:user_id])
    following_user = User.find_by!(id: follow_params[:following_user_id])
    Follower.find_or_create_by!(user: user, following_user: following_user)
    render json: {
      follower: {
        id: user.id,
        following_user_id: following_user.id
      }
    }, status: :ok
  end

  def unfollow
    destroy_id = Follower.find_by(
      user_id: unfollow_params[:user_id],
      following_user_id: unfollow_params[:unfollow_user_id]
    )&.id
    Follower.destroy(destroy_id) if destroy_id
  end

  private

  def create_user_params
    params.permit(:name)
  end

  def follow_params
    params.permit(:user_id, :following_user_id)
  end

  def unfollow_params
    params.permit(:user_id, :unfollow_user_id)
  end
end
