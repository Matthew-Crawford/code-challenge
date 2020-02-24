module SessionsHelper

  def log_in(user)
    session[:uuid] = user.uuid
  end

  def logged_in?
    !session[:uuid].nil?
  end
end