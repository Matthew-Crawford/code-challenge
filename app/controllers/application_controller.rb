class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  include SessionsHelper

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      user = User.find_by_username username
      unless user.nil?
        if user.authenticate(password) and user.status == 'active'
          return true
        end
      end
    end
  end
end
