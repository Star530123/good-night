class ApplicationController < ActionController::Base
  include Error::Handler

  protect_from_forgery with: :null_session

  protected

  # In this project we don't implement registraion API and the user model just have 'id' and 'name'.
  # But in normal case users can login the application and use the 'good night' service.
  # So I keep the login_user method. We can easily change login logic here if the requirement changes in the future.
  def login_user
    @login_user = User.find_by!(id: params[:user_id])
  end
end
