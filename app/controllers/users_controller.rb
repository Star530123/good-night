class UsersController < ApplicationController
  def index
    render json: User.all.select(:id, :name), status: :ok
  end

  def create
    user = User.create!(name: create_user_params)
    render json: user.as_json(only: [:id, :name]), status: :ok
  end

  def follow
    following_user = User.find_by!(id: follow_params[:following_user_id])
    Follower.find_or_create_by!(user: login_user, following_user: following_user)
    render json: {
      follower: {
        id: login_user.id,
        following_user_id: following_user.id
      }
    }, status: :ok
  end

  def unfollow
    destroy_id = Follower.find_by(
      user: login_user,
      following_user_id: unfollow_params[:unfollow_user_id]
    )&.id
    Follower.destroy(destroy_id) if destroy_id
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
