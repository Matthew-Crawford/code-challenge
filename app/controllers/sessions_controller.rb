class SessionsController < ApplicationController


  def new

  end

  def create
    user = User.find_by_username(params[:session][:username])
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_to root_path
    else
      render 'new'
    end

  end

  def destroy

  end


end
