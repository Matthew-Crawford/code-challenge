class UsersController < ApplicationController

  def show

  end

  def create
    @user = User.new(user_params)
    @user.status = 'active'
    @user.save
    redirect_to root_path
  end

  def new
    @user = User.new
  end

  def index

  end

  private
  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation)
  end
end
