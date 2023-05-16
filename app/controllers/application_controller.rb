class ApplicationController < ActionController::Base
  include Error::Handler

  protect_from_forgery with: :null_session
end
