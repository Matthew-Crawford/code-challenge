require 'csv'

class MainController < ApplicationController

  def new
    unless logged_in?
      redirect_to '/login'
    end
  end

  def create
    if logged_in?
      verification = EmailVerification.new(:address => params[:address][:email])
      verification.save
      flash.now[:success] = (verification.verification_status == 'valid') ? "Email is valid!" : "Email is not valid!"
      render 'main/new'
    end
  end

  def import
    if logged_in?
      @verification_map = Hash.new

      if CSV.foreach(params[:file].path, headers: true).count > 100
        render 'main/new'
        return
      end

      CSV.foreach(params[:file].path, headers: true) do | row |
        verification = EmailVerification.new(:address => row)
        verification.save

        @verification_map[verification.address] = verification.verification_status
      end
      render 'main/new'
    end
  end

end
